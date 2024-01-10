*** Variables ***
${home}             (//a[@aria-label='logo'])[1]

${banner}           //div[@class='lz-inner-ctn']
${btnCloseBanner}   //div[@class='lz-inner-ctn']//div[@class='aim-banner__content-banner_close aimkt-close-popup']


${txtSearch}        //div[@class='wrapBoxSearch hidden-sm hidden-xs']//input[@placeholder='Bạn muốn tìm sản phẩm gì ?']
${btnSearch}        //button[contains(text(),'Tìm kiếm ngay')]

${btnWishList}      //div[@class='iconHeader col-lg-2 col-md-2']//a[@aria-label='wishlist']

${modalCart}        //div[@class='cartHeaderContent']
${btnIconCart}      //a[@class='cartBtnOpen']
${btnCart}          //a[contains(text(),'Xem giỏ hàng')]

${btnRemoveFav}     //td[@class='actitonWislist']/a[@class='removeFav']
