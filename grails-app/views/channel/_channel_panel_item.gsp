<ul>
	<g:each in="${channels}" var="channel">
		<li class="">
			<a class="gotocategorylink text-uppercase" 
				href="/${channel.name}" target="_top">
				<g:message code="channel.name.i18n.${channel.name}" default="${channel.name}" />
			</a>
		</li>
	</g:each>
</ul>