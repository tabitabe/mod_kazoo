<table id="admin_portal_current_calls_table" class="table display table-striped table-condensed">
<thead>
  <tr>
    <th style="text-align: center;">CallId</th>
    <th style="text-align: center;">User</th>
    <th style="text-align: center;">Device</th>
    <th style="text-align: center;">Caller Number</th>
    <th style="text-align: center;">Callee Number</th>
    <th style="text-align: center;">Xfer</th>
    <th style="text-align: center;">Hang Up</th>
  </td>
</thead>
<tbody id="currentcallstableid">
  {% for running_call in m.kazoo.kz_list_account_channels %} 
  {% if running_call["direction"]=="outbound" %}
     <tr>
        <td style="text-align: center;">{{ running_call["uuid"]|cleanout }}</td>
        <td style="text-align: center;"> </td>
        <td style="text-align: center;"> </td>
        <td style="text-align: center;"> </td>
        <td style="text-align: center;">{{ running_call["destination"] }} </td>
        <td style="text-align: center;"><i class="dark-1 icon-telicon-failover"><i></td>
        <td style="text-align: center;"><i class="dark-1 icon-telicon-hangup"><i></td>
     </tr>
  {% endif %}
  {% endfor %}
</tbody>
</table>

{% javascript %}
  function myreplace(stringtowork){
      stringtowork.replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-');
  };
  var oTable = $('#admin_portal_current_calls_table').dataTable({
    "pagingType": "simple",
    "bFilter" : true,
    "aaSorting": [[ 0, "desc" ]],
    "aLengthMenu" : [[5, 15, -1], [5, 15, "All"]],
    "iDisplayLength" : 5,
    "oLanguage" : {
            "sInfoThousands" : " ",
            "sLengthMenu" : "_MENU_ {_ lines per page _}",
            "sSearch" : "{_ Filter _}:",
            "sZeroRecords" : "{_ Nothing found, sorry _}",
            "sInfo" : "{_ Showing _} _START_ {_ to _} _END_ {_ of _} _TOTAL_ {_ entries _}",
            "sInfoEmpty" : "{_ Showing 0 entries _}",
            "sInfoFiltered" : "({_ Filtered from _} _MAX_ {_ entries _})",
            "oPaginate" : {
                    "sPrevious" : "{_ Back _}",
                    "sNext" : "{_ Forward _}"
            }
    },
    "columnDefs": [
                { "targets": [ 0 ], "visible": false },
                { "targets": [ 1 ], className: "td-center" },
                { "targets": [ 2 ], className: "td-center" },
                { "targets": [ 3 ], className: "td-center" },
                { "targets": [ 4 ], className: "td-center" },
                { "targets": [ 5 ], className: "td-center" },
                { "targets": [ 6 ], className: "td-center" }
    ],
    "fnCreatedRow": function( nRow, aData, iDataIndex ) {
         $(nRow).attr('id', aData[0]);
    }
  });

  var socket = io.connect('{{ m.config.mod_kazoo.kazoo_blackhole_url.value }}');
  socket.emit("subscribe", { account_id: "{{ m.session.kazoo_account_id }}", auth_token: "{{ m.session.kazoo_auth_token }}", binding: "call.CHANNEL_CREATE.*"});
  socket.emit("subscribe", { account_id: "{{ m.session.kazoo_account_id }}", auth_token: "{{ m.session.kazoo_auth_token }}", binding: "call.CHANNEL_ANSWER.*"});
  socket.emit("subscribe", { account_id: "{{ m.session.kazoo_account_id }}", auth_token: "{{ m.session.kazoo_auth_token }}", binding: "call.CHANNEL_DESTROY.*"});
  socket.on("CHANNEL_CREATE", function (data) {
    if ( data["Other-Leg-Call-ID"] ) {
        $(".dataTables_empty").remove();
        console.log(data["Call-ID"].toString());
        row_id = data["Call-ID"].replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-');
        oTable.api().row.add([row_id, 
                              data["Other-Leg-Caller-ID-Number"], 
                              data["Other-Leg-Caller-ID-Number"], 
                              data["Caller-ID-Number"], 
                              data["Callee-ID-Number"], 
                              '<i class="dark-1 icon-telicon-failover"><i>', 
                              '<i class="dark-1 icon-telicon-hangup"><i>' ]).draw();
    }
    console.log(data); // data = EventJObj
  });
  socket.on("CHANNEL_ANSWER", function (data) {
    console.log(data);
  });
  socket.on("CHANNEL_DESTROY", function (data) {
    oTable.api().row('#'+data["Call-ID"].replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-')).remove().draw();
    console.log(data);
  });
{% endjavascript %}
