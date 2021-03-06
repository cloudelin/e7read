
$(function() {
	$('.topmenu-li').hover(
		function(e) {
			var el = $(e.target);
			if (el.prop("tagName") == "LI") {
				el = $('a', el);
			}
			var pos = el.position();
			$(this).find('.dropdown-menu').first().css('top', pos.top + el.height() - 2).css('left', pos.left);
			$(this).find('.dropdown-menu').first().css('display', 'block');
		}, function(e) {
			$(this).find('.dropdown-menu').first().hide(100);
		}
	);
	
	var is_safari_or_uiwebview = /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent);
	if (is_safari_or_uiwebview) {
		$('.hidden-xs').hide();
	}
});

function hideCategoryMenu() {
	$('.side-menu-float').hide(200);
}

function showCategoryMenu() {
	$('.side-menu-float').show(300);
}