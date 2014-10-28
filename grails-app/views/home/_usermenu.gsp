<%-- User Login --%>
<sec:ifLoggedIn>
	<div class="usermenu-table">
		<div>
			<g:link uri="/content/personal/${channel.name}" class="koobe-btn koobe-btn-normal">
		        <i class="fa fa-archive"></i> <!-- My Contents  -->
		    </g:link>
	    </div>
	    <div>
            <g:link uri="/content/create/${channel.name}" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-pencil"></i> <!-- Create -->
            </g:link>
	    </div>
	    <div>
            <g:link uri="/me" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-user"></i>
                <!-- <sec:loggedInUserInfo field="fullName"/> -->
            </g:link>
	    </div>
        <div>
            <g:link controller="map" action="explore" params="[channel: 'e7read']" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-map-marker"></i> <!-- Explore in Map  -->
            </g:link>
        </div>
        <div>
            <g:link uri="javascript: confirmLogout();" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-sign-out"></i> <!-- Logout -->
            </g:link>
	    </div>
	    <div class="menu-blank">&nbsp;</div>
	</div>
</sec:ifLoggedIn>
<sec:ifNotLoggedIn>
	<div class="usermenu-table">
        <div>
            <g:link uri="/content/create/${channel.name}" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-pencil"></i> <!-- Create -->
            </g:link>
        </div>
        <div>
            <g:link controller="map" action="explore" params="[channel: 'e7read']" class="koobe-btn koobe-btn-normal">
                <i class="fa fa-map-marker"></i> <!-- Explore in Map  -->
            </g:link>
        </div>
		<div>
			<oauth:connect provider="facebook" id="facebook-connect-link" class="koobe-btn koobe-btn-normal">
		        <span class="fa fa-facebook-square"></span>
		        <!-- Sign-in with Facebook -->
		    </oauth:connect>
		</div>
		<div class="menu-blank">&nbsp;</div>
	</div>
</sec:ifNotLoggedIn>