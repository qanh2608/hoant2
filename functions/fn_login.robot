*** Settings ***
Library    Selenium2Library
Library    String
Library    Collections
Library    XML
Resource    ../locators/locatorHome.robot
Resource    ../locators/locatorProdDetail.robot
Resource    ../locators/locatorSearchResult.robot
Test Setup     Open New Browser    ${url}      ${browser}
Test Teardown      Close Browser

*** Variables ***
@{list}  2  1
${sleep}    2s
${url}    https://jm.com.vn/
${browser}  chrome

#value search
${key}  Áo
${prodTop}      //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active']

*** Test Cases ***
Search JM
    Search By Keyword    ${key}
    Page Should Contain    sản phẩm tìm kiếm với kết quả "${key}"
    Capture Page Screenshot

Filter Size
    Search By Keyword    ${key}
    Filter By Size    L
    Filter By Size    S
#    Filter By Size    test

Filter Color
    Search By Keyword    ${key}
#    Filter By Color    Hồng Phớt
    Filter By Color    Cam
#    Filter By Color    test

Prod Favorite
    Click On Locator    ${prodTop}
    ${prodName}     Get Text    ${lblProdName}
    Add Prod Favorite    ${prodName}
    Remove Prod Favorite    ${prodName}

Add to Cart
    @{prodNameList}       Create List
    @{prodIdList}         Create List
    @{priceProdList}      Create List
    @{quatityProdList}    Create List

#Add san pham vao gio hang
    FOR    ${item}    IN    @{list}
        Click On Locator    //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active'][${item}]//div[@class='productImage']
        ${prodName}     Get Text    ${lblProdName}
        @{colorList}    Create List
        @{colorList}    Get WebElements    ${itemColor}
        FOR    ${color}    IN    @{colorList}
            Log    ${color}
            Click On Locator    ${color}
            @{sizeList}     Set Variable    L   M   S
            FOR    ${size}    IN    @{sizeList}
                ${size}     Set Variable    //p[@class='size req']/a[contains(text(),'${size}')]
                Log    ${size}
                ${checkOutStock}    Get Element Attribute    ${size}    title
                Log    ${checkOutStock}
                IF    '${checkOutStock}' != 'Sản phẩm tạm thời hết hàng!'
                    Click On Locator    ${size}
                    ${quatity}      Get Element Attribute    ${txtQuantity}    max
                    IF    ${quatity} > 50
                        Click On Locator    ${btnPlusQuantity}
                        ${quatity}  Get Element Attribute    ${txtQuantity}    value
                        ${price}    Get Text    ${lblPrice}
                        ${prodId}   Get Element Attribute    ${btnQuickCart}    selid
                        Click On Locator    ${btnQuickCart}
                        Click On Locator    ${btnMinusQuantity}
                    ELSE
                        ${quatity}  Get Element Attribute    ${txtQuantity}    value
                        ${price}    Get Text   ${lblPrice}
                        ${prodId}   Get Element Attribute    ${btnQuickCart}    selid
                        Click On Locator    ${btnQuickCart}
                    END
                    Append To List    ${prodNameList}      ${prodName}
                    Append To List    ${prodIdList}        ${prodId}
                    Append To List    ${priceProdList}     ${price}
                    Append To List    ${quatityProdList}   ${quatity}
                END
            END
        END
        Click On Locator    ${home}
    END

    Log Many    @{prodNameList}
    Log Many    @{prodIdList}
    Log Many    @{priceProdList}
    Log Many    @{quatityProdList}

# Vao man hinh gio hang
    Click On Locator    ${btnIconCart}
    Click On Locator    ${btnCart}

    ${max_i}    Get Length    ${prodIdList}
    Log    ${max_i}
    ${x}    Set Variable    0

#total_item = gia o man detail san pham * so luong san pham
    ${total_item}   Set Variable    0
#total_gia = gia o man gio hang
    ${total_gia}    Set Variable    0
    WHILE  ${x} < ${max_i}
        ${prod}         Get From List    ${prodIdList}    ${x}
        ${priceItem}    Get From List    ${priceProdList}    ${x}
        ${priceItem}    Replace String  ${priceItem}  ,   ${EMPTY}
        ${priceItem}    Replace String  ${priceItem}  đ   ${EMPTY}
        ${quatityItem}  Get From List    ${quatityProdList}    ${x}
        ${priceItem}    Evaluate    ${quatityItem}*${priceItem}

        ${soluong}  Get Element Attribute    //tr[@data-id='${prod}']/td[@class='quantityProduct']//input    value
        ${gia}      Get Text    //tr[@data-id='${prod}']//div[@class='priceWislist']/span
        ${gia}    Replace String  ${gia}  ,   ${EMPTY}
        ${gia}    Replace String  ${gia}  đ   ${EMPTY}

#        ${ssSoLuong}    Run Keyword And Return Status    Should Be Equal As Numbers    ${quatityItem}    ${soluong}
#        Log    ${x} | San pham: ${prod} | Gia mua: ${priceItem} | Gia hoa don: ${gia} | So luong mua: ${quatityItem} | So luong hoa don: ${soluong}
#
#        IF    "${ssSoLuong}" == "True"
#            Should Be Equal As Numbers    ${gia}    ${priceItem}
#        END

        ${total_item}   Evaluate    ${total_item} + ${priceItem}
        ${total_gia}    Evaluate    ${total_gia} + ${gia}
        ${x}    Evaluate    ${x} + 1
    END

    Log    ${total_item}
    Log    ${total_gia}

#total_end = tong hoa don hien thi o man gio hang
    ${total_end}   Get Text    //strong[@class='totals_price2']
    ${total_end}    Replace String  ${total_end}  ,   ${EMPTY}
    ${total_end}    Replace String  ${total_end}  đ   ${EMPTY}
    Log    ${total_end}

    ${compare_totalItem_totalEnd}    Run Keyword And Return Status    Should Be Equal As Numbers    ${total_item}    ${total_end}
    Log To Console   | Tong mua: ${total_item} | Tong hoa don: ${total_gia} | Tong all: ${total_end}
    IF    "${compare_totalItem_totalEnd}" == "True"
         Should Be Equal As Numbers    ${total_item}    ${total_gia}
    END

*** Keywords ***
Open New Browser
    [Arguments]     ${url}      ${browser}
    Open Browser    ${url}      ${browser}
    Maximize Browser Window
    Sleep    ${sleep}

Close Banner
    ${showBanner}   Run Keyword And Return Status    Page Should Not Contain Element    ${banner}
    IF    '${showBanner}' == 'False'
        Click Element   ${btnCloseBanner}
        Sleep    ${sleep}
    END

Close Cart
    ${showCart}     Get Element Attribute    ${modalCart}    style
    IF    '${showCart}' == 'display: block;'
        Click Element    ${btnIconCart}
    END

Click On Locator
    [Arguments]     ${locator}
    Close Banner
    Close Cart
    Wait Until Element Is Enabled    ${locator}
#    Capture Element Screenshot    ${locator}    EMBED
    Click Element    ${locator}
    Sleep    ${sleep}
#    Capture Page Screenshot     EMBED

Input Value
    [Arguments]     ${locator}      ${value}
    Close Banner
    Wait Until Element Is Enabled    ${locator}
    Capture Element Screenshot    ${locator}    EMBED
    Input Text    ${locator}    ${value}
    Sleep    ${sleep}
#    Capture Page Screenshot     EMBED

Search By Keyword
    [Arguments]     ${key}
    Input Value    ${txtSearch}  ${key}
    Click On Locator    ${btnSearch}

Filter By Size
    [Arguments]     ${size}
    IF    "${size}" == "FREE"
        Click On Locator    ${btnSize}li[@data-value='1755563']
    ELSE IF     "${size}" == "38"
        Click On Locator    ${btnSize}li[@data-value='1747446']
    ELSE IF     "${size}" == "XL"
        Click On Locator    ${btnSize}li[@data-value='1747441']
    ELSE IF     "${size}" == "L"
        Click On Locator    ${btnSize}li[@data-value='1747439']
    ELSE IF     "${size}" == "M"
        Click On Locator    ${btnSize}li[@data-value='1747437']
    ELSE IF     "${size}" == "S"
        Click On Locator    ${btnSize}li[@data-value='1747435']
    ELSE
       Log    Not Found Color ${size}
       Page Should Contain Element    ${size}
    END
    Capture Page Screenshot
    
Filter By Color
    [Arguments]     ${color}
    ${checkColor}   Run Keyword And Return Status    Page Should Contain Element    ${btnColor}label[@title='${color}']
    IF    "${checkColor}" == "True"
        Click On Locator    ${btnColor}label[@title='${color}']
        Capture Page Screenshot
    ELSE
        Log    Not Found Color ${color}
        Page Should Contain Element    ${btnColor}label[@title='${color}']
    END

Add Prod Favorite
    [Arguments]     ${prodName}
    Click On Locator    ${btnAddFavorite}
    Handle Alert    ACCEPT
    Sleep    ${sleep}
    Click On Locator    ${btnWishList}
    Page Should Contain    ${prodName}
    
Remove Prod Favorite
    [Arguments]     ${prodName}
    Page Should Contain    ${prodName}
    Click On Locator    ${btnRemoveFav}
    Sleep    ${sleep}
    Handle Alert    ACCEPT
    Sleep    ${sleep}
    Page Should Not Contain    ${prodName}
    
Verify Element Text
    [Arguments]     ${locator}      ${text}
    Wait Until Page Contains Element    ${locator}      ${sleep}
    Element Text Should Be      ${locator}      ${text}
#    Capture Element Screenshot  ${locator}      EMBED