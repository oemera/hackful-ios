function redirectiPhoneToAppStore() {
	var check = false;
	if (navigator.userAgent.toLowerCase().indexOf("iphone") > -1 
		 && document.referrer.indexOf("kicker.de")==-1 
		 && document.referrer.indexOf("localhost")==-1) {
		
		window.location.href = "itms://apple.com....";
	}
}