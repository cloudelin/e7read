<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="main"/>
  <title></title>
</head>
<body>
<div class="container">
  <g:link action="legacyImport">Import</g:link>
  <div class="page-header">
    <h2>Legacy EPUB</h2>
  </div>
  <table class="table table-bordered table-striped table-hover table-responsive">
    <tr>
      <th>#</th>
      <th width="30%">Book Title</th>
      <th>Description</th>
      <th>Actions</th>
    </tr>
    <g:each in="${legacies}" var="legacy" status="i">
      <tr>
        <td>${i+1}</td>
        <td>
          <small>${legacy.title}</small>
        </td>
        <td>
          <p><small>${legacy.description}</small></p>
          <p class="text-info"><small>${legacy.contributor} / ${legacy.date} / ${legacy.language} / ${legacy.subject}</small></p>
        </td>
        <td>
          <div class="btn-group btn-group-xs">
            <button class="btn btn-default btn-xs btnFetchXML" data-file="${file}">Get Data</button>
          </div>
        </td>
      </tr>
    </g:each>
  </table>
</div>

<script type="application/javascript">
  $(function() {
    $('.btnFetchXML').click(function() {
      var file = $(this).data('file');

      console.log("Fetch XML: " + file);

      $.ajax('/book/legacyFetchXML', {
        type: 'post',
        data: {
          file: file
        },
        success: function() {
          console.log("XML fetched.");
        }
      })

      return false;
    });
  });
</script>
</body>
</html>