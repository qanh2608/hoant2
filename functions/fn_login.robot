*** Settings ***
Library     Selenium2Library
Test Setup     Open New Browser    ${url}      ${browser}
Test Teardown      Close Browser

*** Variables ***
${i}        4
${sleep}    2s
${url}    https://jm.com.vn/
${browser}  chrome
${txtSearch}    //div[@class='wrapBoxSearch hidden-sm hidden-xs']//input[@placeholder='Bạn muốn tìm sản phẩm gì ?']
${btnSearch}    //button[contains(text(),'Tìm kiếm ngay')]
${btnAddFavorite}   //a[@title='Thêm vào yêu thích']
${btnWishList}      //div[@class='iconHeader col-lg-2 col-md-2']//a[@aria-label='wishlist']

#value search
${key}  Áo
${sizeL}        //div[@class='filter-size attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i2' and @data-value='1747439']
${colorPink}    //div[@class='filter-color attributeFilter category-filter']/ul[@style='display: block']/li[@data-column='i1' and @data-value='1849463']
${prodTop}      //div[@class='owl-item active'][${i}]

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
*** Keywords ***
Open New Browser
    [Arguments]     ${url}      ${browser}
    Open Browser    ${url}      ${browser}
    Maximize Browser Window
    Sleep    ${sleep}

Click On Locator
    [Arguments]     ${locator}
    Wait Until Element Is Enabled    ${locator}
    Capture Element Screenshot    ${locator}    EMBED
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