*** Settings ***
Library     Selenium2Library
Test Setup     Open New Browser    ${url}      ${browser}
Test Teardown      Close Browser

*** Variables ***
${i}        1
${size}     L
${sleep}    2s
${url}    https://jm.com.vn/
${browser}  chrome
${txtSearch}    //div[@class='wrapBoxSearch hidden-sm hidden-xs']//input[@placeholder='Bạn muốn tìm sản phẩm gì ?']
${btnSearch}    //button[contains(text(),'Tìm kiếm ngay')]
${btnAddFavorite}   //a[@title='Thêm vào yêu thích']
${btnWishList}      //div[@class='iconHeader col-lg-2 col-md-2']//a[@aria-label='wishlist']
${btnIconCart}      //a[@class='cartBtnOpen']
${btnCart}          //a[contains(text(),'Xem giỏ hàng')]
${selectColor}      //div[@class='colorPicker clearfix']//span[${i}]
${selectSize}       //div[@class='sizePicker clearfix']//a[contains(text(),'${size}')]
${txtQuantity}      //input[@class='qty-detail input-text qty-view']
${btnPushQuantity}  //button[@class='btn-cts btn-plus-view']
${btnBuyNow}       //button[@id='buyNow']
#value search
${key}  Áo
${sizeL}        //div[@class='filter-size attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i2' and @data-value='1747439']
${colorPink}    //div[@class='filter-color attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i1' and @data-value='1849463']
${prodTop}      //div[@class='productList hotProductList owl-carousel owl-loaded owl-drag']//div[@class='owl-item active'][${i}]

*** Test Cases ***
Search JM
    Input Value    ${txtSearch}  ${key}
    Click On Locator    ${btnSearch}
    Page Should Contain    sản phẩm tìm kiếm với kết quả "${key}"
    Capture Page Screenshot

Filter Size
    Input Value    ${txtSearch}  ${key}
    Click On Locator    ${btnSearch}
    Click On Locator    ${sizeL}

Filter Color
    Input Value    ${txtSearch}  ${key}
    Click On Locator    ${btnSearch}
    Click On Locator    ${colorPink}

Prod Favorite
    Click On Locator    ${prodTop}
    ${prodName}     Get Text    //h1[@class='title-head']
#    Add
    Click On Locator    ${btnAddFavorite}
    Handle Alert    ACCEPT
    Sleep    ${sleep}
    Click On Locator    ${btnWishList}
    Page Should Contain    ${prodName}
#   Delete
    Click On Locator    (//a[contains(text(),'${prodName}')])[1]/parent::*/parent::*//a[@class='removeFav']
    Handle Alert    ACCEPT
    Sleep    ${sleep}
    Page Should Not Contain    ${prodName}

Add to Cart
    Click On Locator    ${prodTop}
    ${prodName}     Get Text    //h1[@class='title-head']
#    Add
    Click On Locator    ${selectColor}
    Click On Locator    ${selectSize}
    Sleep    ${sleep}
    ${quatity}      Get Element Attribute    ${txtQuantity}    max
    IF    ${quatity} > 5
        Click On Locator    ${btnPushQuantity}
        Click On Locator    ${btnBuyNow}
    ELSE
        Click On Locator    ${btnBuyNow}
    END
    Page Should Contain    ${prodName}

*** Keywords ***
Open New Browser
    [Arguments]     ${url}      ${browser}
    Open Browser    ${url}      ${browser}
    Maximize Browser Window
    Sleep    ${sleep}

Click On Locator
    [Arguments]     ${locator}
    Wait Until Element Is Enabled    ${locator}
#    Capture Element Screenshot    ${locator}    EMBED
    Click Element    ${locator}
    Sleep    ${sleep}
#    Capture Page Screenshot     EMBED

Input Value
    [Arguments]     ${locator}      ${value}
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