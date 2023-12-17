*** Settings ***
Library     Selenium2Library
Library    String
Library    Collections
Library    XML
Test Setup     Open New Browser    ${url}      ${browser}
Test Teardown      Close Browser

*** Variables ***
#@{list}  4  6
@{list}  6
${sleep}    2s
${url}    https://jm.com.vn/
${browser}  chrome

${home}         (//a[@aria-label='logo'])[1]
${banner}       //div[@class='lz-inner-ctn']
${btnCloseBanner}   //div[@class='lz-inner-ctn']//div[@class='aim-banner__content-banner_close aimkt-close-popup']
${modalCart}    //div[@class='cartHeaderContent']
${txtSearch}    //div[@class='wrapBoxSearch hidden-sm hidden-xs']//input[@placeholder='Bạn muốn tìm sản phẩm gì ?']
${btnSearch}    //button[contains(text(),'Tìm kiếm ngay')]
${btnAddFavorite}   //a[@title='Thêm vào yêu thích']
${btnWishList}      //div[@class='iconHeader col-lg-2 col-md-2']//a[@aria-label='wishlist']
${btnIconCart}      //a[@class='cartBtnOpen']
${btnCart}          //a[contains(text(),'Xem giỏ hàng')]
${lblPrice}         //span[@class='discountPrice tp_product_detail_price']
${txtQuantity}      //input[@class='qty-detail input-text qty-view']
${btnPushQuantity}  //button[@class='btn-cts btn-plus-view']
${btnBuyNow}       //button[@id='buyNow']
${btnQuickCart}       //button[@id='addQuickCart']
#value search
${key}  Áo
${sizeL}        //div[@class='filter-size attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i2' and @data-value='1747439']
${colorPink}    //div[@class='filter-color attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i1' and @data-value='1849463']
${prodTop}      //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active']

*** Test Cases ***
#Search JM
#    Input Value    ${txtSearch}  ${key}
#    Click On Locator    ${btnSearch}
#    Page Should Contain    sản phẩm tìm kiếm với kết quả "${key}"
#    Capture Page Screenshot
#
#Filter Size
#    Input Value    ${txtSearch}  ${key}
#    Click On Locator    ${btnSearch}
#    Click On Locator    ${sizeL}
#
#Filter Color
#    Input Value    ${txtSearch}  ${key}
#    Click On Locator    ${btnSearch}
#    Click On Locator    ${colorPink}
#
#Prod Favorite
#    Click On Locator    ${prodTop}
#    ${prodName}     Get Text    //h1[@class='title-head']
##    Add
#    Click On Locator    ${btnAddFavorite}
#    Handle Alert    ACCEPT
#    Sleep    ${sleep}
#    Click On Locator    ${btnWishList}
#    Page Should Contain    ${prodName}
##   Delete
#    Click On Locator    //td[@class='actitonWislist']/a[@class='removeFav']
#    Sleep    ${sleep}
#    Handle Alert    ACCEPT
#    Sleep    ${sleep}
#    Page Should Not Contain    ${prodName}

Add to Cart
    @{prodNameList}       Create List
    @{prodIdList}         Create List
    @{priceProdList}      Create List
    @{quatityProdList}    Create List
    FOR    ${item}    IN    @{list}
        Click On Locator    //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active'][${item}]//div[@class='productImage']
        ${prodName}     Get Text    //h1[@class='title-head']
        @{colorList}    Get WebElements    //span[@class='itemColor']
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
                    IF    ${quatity} > 5
                        Click On Locator    ${btnPushQuantity}
                        ${quatity}  Get Element Attribute    ${txtQuantity}    value
                        ${price}    Get Text    ${lblPrice}
                        ${prodId}   Get Element Attribute    ${btnQuickCart}    selid
                        Click On Locator    ${btnQuickCart}
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

    Click On Locator    ${btnIconCart}
    Click On Locator    ${btnCart}

    ${x}    Set Variable    0
    ${prod}     Get From List    ${prodIdList}    ${x}
    ${priceItem}    Get From List    ${priceProdList}    ${x}
    ${quatityItem}  Get From List    ${quatityProdList}    ${x}

    ${soluong}  Get Element Attribute    //tr[@data-id='${prod}']/td[@class='quantityProduct']//input    value
    ${gia}      Get Text    //tr[@data-id='${prod}']//div[@class='priceWislist']/span

    IF    "${priceItem}" == "${gia}"
        IF    "${quatityItem}" == "${soluong}"
            Log    passsssss
        END
    END     

#    ${total}    Set Variable    0
#    @{array}    Get WebElements    //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active']
#    Log Many    @{array}
#    Log    ${x}
#    Log    ${total}
#    WHILE  ${x} < 2
#        ${sl}   Get Element Attribute    //tr[@class = 'idProduct'][${x}]/td[@class = 'quantityProduct']//input[@name = 'Lines']   value
#        ${price1}    Get Text    //tr[@class = 'idProduct'][${x}]//div[@class = 'priceWislist']/span
#        ${price1}    Replace String  ${price1}  ,   ${EMPTY}
#        ${price1}    Replace String  ${price1}  đ   ${EMPTY}
#        ${total}    Evaluate    ${total} + ${sl}*${price1}
#        Log     ${total}
#        ${x}    Evaluate    ${x} + 1
#        Log    ${x}
#    END
#
#    ${total_end}   Get Text    //strong[@class='totals_price2']
#    ${total_end}    Replace String  ${total_end}  ,   ${EMPTY}
#    ${total_end}    Replace String  ${total_end}  đ   ${EMPTY}
#    Log    ${total_end}
#
#    IF    ${total} == ${total_end}
#        Log To Console    PASS ${total} = ${total_end}
#    ELSE
#        Log To Console    FAIL ${total} != ${total_end}
#    END

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

Verify Element Text
    [Arguments]     ${locator}      ${text}
    Wait Until Page Contains Element    ${locator}      ${sleep}
    Element Text Should Be      ${locator}      ${text}
#    Capture Element Screenshot  ${locator}      EMBED