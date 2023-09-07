document.getElementById('multitab_route').addEventListener('click', function() {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        let activeTab = tabs[0];
        chrome.scripting.executeScript({
            target: {tabId: activeTab.id},
            function: navigateToRoute,
            args: ['/route1'] // Replace this with your route path
        });
    });
});

function navigateToRoute(route) {
    window.location.href = window.location.origin + route;
}
