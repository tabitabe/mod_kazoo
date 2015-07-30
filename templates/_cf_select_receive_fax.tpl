{% wire id="form_cf_select_receive_fax" type="submit" postback="cf_select_receive_fax" delegate="mod_kazoo" %}
<form id="form_cf_select_receive_fax" method="post" action="postback">
    <div class="form-group">
      <div class="row">
        <div class="col-sm-6">
            <select id="user_selector" name="selected" class="form-control margin-bottom-xs" style="text-align:center;">
              {% for option in m.kazoo.kz_list_account_users_short %}
                {% if option[1] %}
                  <option value="{{ option[1] }}" {% if option[1] == kz_element_id %}selected{% endif %}>{{ option[2] }}</option>
                {% endif %}
              {% endfor %}
            </select>
        </div>
        <div id="number_input_div"class="col-sm-6">
          <label for="t_38_checkbox">Enable T.38?</label>
          <input id="t_38_checkbox" name="t_38_checkbox"type="checkbox" checked>
        </div>
      </div>
    </div>
    <input type="hidden" name="element_id" value="{{ element_id }}">
</form>
<div class="form-group">
  <div class="row">
    <div class="col-sm-12">
      <button id="button_cf_select_receive_fax" class="col-xs-12 btn btn-zprimary margin-bottom-xs">Save</button>
    </div>
  </div>
</div>
{% wire id="button_cf_select_receive_fax" action={script script="$('#"++element_id++"_details').text(($('#user_selector option:selected').text()))"}
                                  action={submit target="form_cf_select_receive_fax"}
%}
{% javascript %}
    $('.modal-header h3').append($('#{{ tool_name }}  div.tool_name').text());
{% endjavascript %}
