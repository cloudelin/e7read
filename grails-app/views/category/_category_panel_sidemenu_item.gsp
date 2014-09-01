<ul>
	<g:each in="${categorys}" var="category">
		<g:if test="${category.enable}">
			<g:if test="${category.categorys}">
				<li class="${active?.equals(category.name)? 'active-item': ''}">
					<a href="${btnaction?.equals('create')? 'javascript: addCategory("'+ category.name +'")': '?c=' + category.name + '&p=1'}">
						<g:message code="category.name.i18n.${category.name}" default="${category.name}" />
					</a>
					<g:render template="/category/category_panel_sidemenu_item" model="[categorys: category.categorys]" />
				</li>
			</g:if>
			<g:else>
				<li class="${active?.equals(category.name)? 'active-item': ''}">
					<a href="${btnaction?.equals('create')? 'javascript: addCategory("'+ category.name +'")': '?c='+category.name+'&p=1'}">
						<g:message code="category.name.i18n.${category.name}" default="${category.name}" />
					</a>
				</li>
			</g:else>
		</g:if>
	</g:each>
</ul>