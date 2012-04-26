function redirectiPhoneToAppStore() {
	if (navigator.userAgent.toLowerCase().indexOf("iphone") > -1) {
		if (confirm("Hackful App\nDownload in the App Store?")) {
			window.location.href = "itms://itunes.apple.com/us/app/hackful/id513593209";
		}
	}
}