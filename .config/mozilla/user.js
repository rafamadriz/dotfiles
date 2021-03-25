// better scrolling
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 250);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 250);
user_pref("general.smoothScroll.mouseWheel.migrationPercent", 0);
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 250);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 450);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 450);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 50);
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 5000);
user_pref("mousewheel.min_line_scroll_amount", 45);
user_pref("toolkit.scrollbox.verticalScrollDistance", 5);

// customization
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user("layers.acceleration.force-enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("svg.context-properties.content.enabled", true);

// PRIVACY

// PREF: Disable Location-Aware Browsing (geolocation)
user_pref("geo.enabled", false);

// PREF: When geolocation is enabled, don't log geolocation requests to the console
user_pref("geo.wifi.logging.enabled", false);

// PREF: Disable WebRTC entirely to prevent leaking internal IP addresses (Firefox < 42)
// NOTICE: Disabling WebRTC breaks peer-to-peer file sharing tools (reep.io ...)
user_pref("media.peerconnection.enabled", false);

// PREF: Don't reveal your internal IP when WebRTC is enabled (Firefox >= 42)
// https://wiki.mozilla.org/Media/WebRTC/Privacy
// https://github.com/beefproject/beef/wiki/Module%3A-Get-Internal-IP-WebRTC
user_pref("media.peerconnection.ice.default_address_only", true); // Firefox 42-51
user_pref("media.peerconnection.ice.no_host", true); // Firefox >= 52

// PREF: Disable WebRTC getUserMedia, screen sharing, audio capture, video capture
// https://wiki.mozilla.org/Media/getUserMedia
// https://blog.mozilla.org/futurereleases/2013/01/12/capture-local-camera-and-microphone-streams-with-getusermedia-now-enabled-in-firefox/
// https://developer.mozilla.org/en-US/docs/Web/API/Navigator
user_pref("media.navigator.enabled", false);
user_pref("media.navigator.video.enabled", false);
user_pref("media.getusermedia.screensharing.enabled", false);
user_pref("media.getusermedia.audiocapture.enabled", false);

// PREF: Disable prefetching of <link rel="next"> URLs
// http://kb.mozillazine.org/Network.prefetch-next
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ#Is_there_a_preference_to_disable_link_prefetching.3F
user_pref("network.prefetch-next", false);

// PREF: Disable DNS prefetching
// http://kb.mozillazine.org/Network.dns.disablePrefetch
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Controlling_DNS_prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// PREF: Disable clipboard event detection (onCut/onCopy/onPaste) via Javascript
// NOTICE: Disabling clipboard events breaks Ctrl+C/X/V copy/cut/paste functionaility in JS-based web applications (Google Docs...)
// https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/dom.event.clipboardevents.enabled
user_pref("dom.event.clipboardevents.enabled", false);

// the header says from which website you're comming (it breaks some websites) [Udemy, Arch Linux Forums]
// values: 0 2
//user_pref("network.http.sendRefererHeader", 0);

// PREF: Enable first-party isolation
// https://bugzilla.mozilla.org/show_bug.cgi?id=1299996
// https://bugzilla.mozilla.org/show_bug.cgi?id=1260931
// https://wiki.mozilla.org/Security/FirstPartyIsolation
// NOTICE: First-party isolation breaks Microsoft Teams
// NOTICE: First-party isolation causes HTTP basic auth to ask for credentials for every new tab (see #425)
user_pref("privacy.firstparty.isolate", true);

// PREF: Enable Firefox Tracking Protection
// https://wiki.mozilla.org/Security/Tracking_protection
// https://support.mozilla.org/en-US/kb/tracking-protection-firefox
// https://support.mozilla.org/en-US/kb/tracking-protection-pbm
// https://kontaxis.github.io/trackingprotectionfirefox/
// https://feeding.cloud.geek.nz/posts/how-tracking-protection-works-in-firefox/
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);

// PREF: Disable webGL
// https://en.wikipedia.org/wiki/WebGL
// https://www.contextis.com/resources/blog/webgl-new-dimension-browser-exploitation/
// breaks some websites
user_pref("webgl.disabled", true);

/* 0105: disable Activity Stream stuff (AS)
 * AS is the default homepage/newtab in FF57+, based on metadata and browsing behavior.
 *    **NOT LISTING ALL OF THESE: USE THE PREFERENCES UI**
 * [SETTING] Home>Firefox Home Content>...  to show/hide what you want ***/
/* 0105a: disable Activity Stream telemetry ***/
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry.ping.endpoint", "");

// Prevents Firefox from sending information about downloaded executable files to Google Safe Browsing to determine whether it should be blocked for safety reasons.
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

// Disables sending additional analytics to web servers.
user_pref("beacon.enabled", false);

user_pref("plugin.scan.plid.all", false);
user_pref("privacy.resistFingerprinting", true);
user_pref("media.eme.enabled", false);
