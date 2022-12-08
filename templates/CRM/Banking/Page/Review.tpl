{*-------------------------------------------------------+
| Project 60 - CiviBanking                               |
| Copyright (C) 2013-2018 SYSTOPIA                       |
| Author: B. Endres (endres -at- systopia.de)            |
| http://www.systopia.de/                                |
+--------------------------------------------------------+
| This program is released as free software under the    |
| Affero GPL v3 license. You can redistribute it and/or  |
| modify it under the terms of this license which you    |
| can read by viewing the included agpl.txt or online    |
| at www.gnu.org/licenses/agpl.html. Removal of this     |
| copyright header is strictly prohibited without        |
| written permission from the original author(s).        |
+--------------------------------------------------------*}
{* This page is generated by CRM/Banking/Page/Review.php *}

  <div id="btx">
    {foreach from=$summary_blocks item=block}
      {$block}
    {/foreach}
  <div class="clear"></div>
  </div>
  <br/>

  <div align="right" class="clearfix" style="width: 100%;">
    <a href="{$url_skip_back}" class="button {if not $url_skip_back}disabled{/if}  ui-icon-seek-prev"><span title="{ts domain='org.project60.banking'}Back{/ts}"><div class="icon previous-icon ui-icon-seek-prev disabled"></div>{ts domain='org.project60.banking'}Back{/ts}</span></a>

    {if $btxstatus.label != 'Processed' AND $btxstatus.label != 'Ignored'}
      <a id="analyseButton" onClick="analysePayment()" class="button"><span title="{ts domain='org.project60.banking'}Analyse (again){/ts}"><div class="icon preview-icon ui-icon-refresh"></div>{ts domain='org.project60.banking'}Analyse (again){/ts}</span></a>
      {if isset($url_skip_forward)}
        <a href="#" onClick="execute_selected()" class="button"><span title="{ts domain='org.project60.banking'}Confirm and Continue{/ts}"><div class="icon next-icon ui-icon-check"></div>{ts domain='org.project60.banking'}Confirm and Continue{/ts}</span></a>
        <a href="{$url_skip_forward}" class="button"><span title="{ts domain='org.project60.banking'}Skip{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip{/ts}</span></a>
        {if $url_skip_processed}
        <a href="{$url_skip_processed}" class="button"><span title="{ts domain='org.project60.banking'}Skip Processed{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip Processed{/ts}</span></a>
        {/if}
      {else}
        <a href="#" onClick="execute_selected()" class="button"><span title="{ts domain='org.project60.banking'}Confirm and Exit{/ts}"><div class="icon next-icon ui-icon-check"></div>{ts domain='org.project60.banking'}Confirm and Exit{/ts}</span></a>
        <a href="{$url_back}" class="button"><span title="{ts domain='org.project60.banking'}Skip and Exit{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip and Exit{/ts}</span></a>
      {/if}
    {else}
      <a id="analyseButton" onClick="analysePayment()" class="button disabled"><span title="{ts domain='org.project60.banking'}Analyse (again){/ts}"><div class="icon preview-icon ui-icon-refresh"></div>{ts domain='org.project60.banking'}Analyse (again){/ts}</span></a>
      {if isset($url_skip_forward)}
        <a href="" class="button disabled"><span title="{ts domain='org.project60.banking'}Confirm and Continue{/ts}"><div class="icon next-icon ui-icon-check"></div>{ts domain='org.project60.banking'}Confirm and Continue{/ts}</span></a>
        <a href="{$url_skip_forward}" class="button"><span title="{ts domain='org.project60.banking'}Skip{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip{/ts}</span></a>
        {if $url_skip_processed}
        <a href="{$url_skip_processed}" class="button"><span title="{ts domain='org.project60.banking'}Skip Processed{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip Processed{/ts}</span></a>
        {/if}
      {else}
        <a href="" class="button disabled"><span title="{ts domain='org.project60.banking'}Confirm and Exit{/ts}"><div class="icon next-icon ui-icon-check"></div>{ts domain='org.project60.banking'}Confirm and Exit{/ts}</span></a>
        <a href="{$url_back}" class="button"><span title="{ts domain='org.project60.banking'}Skip and Exit{/ts}"><div class="icon next-icon ui-icon-seek-next"></div>{ts domain='org.project60.banking'}Skip and Exit{/ts}</span></a>
      {/if}
    {/if}
    {if $new_ui_enabled && $back_to_statement_lines}
      <a href="{$url_back}" class="button" style="float:right;">
        <span title="{ts domain='org.project60.banking'}Back{/ts}"><div class="icon back-icon ui-icon-arrowreturnthick-1-w"></div>{ts domain='org.project60.banking'}Back to statement lines{/ts}</span>
      </a>
    {elseif $new_ui_enabled && !$back_to_statement_lines}
      <a href="{$url_back}" class="button" style="float:right;">
        <span title="{ts domain='org.project60.banking'}Back{/ts}"><div class="icon back-icon ui-icon-arrowreturnthick-1-w"></div>{ts domain='org.project60.banking'}Back to statements{/ts}</span>
      </a>
    {else}
      <a href="{$url_back}" class="button" style="float:right;">
        <span title="{ts domain='org.project60.banking'}Back{/ts}"><div class="icon back-icon ui-icon-arrowreturnthick-1-w"></div>{ts domain='org.project60.banking'}Back to transaction list{/ts}</span>
      </a>
    {/if}
  </div>

  {if $btxstatus.label != 'Processed' AND $btxstatus.label != 'Ignored'}
    <br/>
    <div id="generating_suggestions" align="center" hidden="1">
      <br/><br/>
      <img name="busy" src="{$config->resourceBase}i/loading.gif"/>
      <font size="+1">{ts domain='org.project60.banking'}Generating suggestions...{/ts}</font>
      <br/><br/>
    </div>
    <table class="suggestions">
      <tr>
        <td  class="layout">
          <table>
            {foreach from=$suggestions item=suggestion name=action_loop}
              <tr  class="suggestion {if $smarty.foreach.action_loop.first}suggestion-selected{/if}">
                <td class="prob" width="60" align="center">
                  <span style="color: {$suggestion.color};">{$suggestion.probability}</span>
                  <input type="radio" name="selected_suggestion" value="{$suggestion.hash}" style="display: none;" {if $smarty.foreach.action_loop.first}checked{/if} />
                </td>
                <td width="10" align="center" style="background-color: {$suggestion.color};"></span>
                </td>
                <td class="suggest">
                  <form id="{$suggestion.hash}" action="{$url_execute}" method="POST">
                  <input type="hidden" name="execute_suggestion" value="{$suggestion.hash}"/>
                  {* These will be generated by the matcher plugins *}
                  <h4 style="color: {$suggestion.color};">{$suggestion.title}</h4>
                  {$suggestion.visualization}
                  {$suggestion.actions}
                  </form>

                  <input type="hidden" class="{$suggestion.hash} banking-user-confirmation" value="{$suggestion.user_confirmation}"/>
                </td>
              <tr>
              {/foreach}
          </table>
        </td>
      </tr>
    </table>

  {else}
    <br/><br/>
    <h2>{$status_message}</h2>
    <br/>
    {$execution_info.visualization}
  {/if}


<!-- Required JavaScript functions -->
{literal}
<script language="JavaScript">

function execute_selected() {
  let selected_suggestion = cj('input[name=selected_suggestion]:checked').val();
  let user_confirmation = cj("input.banking-user-confirmation." + selected_suggestion).val();
  if (user_confirmation && user_confirmation.length > 0) {
    // there is a user confirmation question -> ask first
    CRM.confirm({
      title: "{/literal}{$user_confirmation_title}{literal}",
      message: user_confirmation
    }).on('crmConfirm:yes', function() {
      document.getElementById(selected_suggestion).submit();
    });
  } else {
    document.getElementById(selected_suggestion).submit();
  }
}

// add listener to all suggestions, so that changes automatically select the given item
cj(".suggestion").on('change', '*', select_suggestion);
cj(".suggestion").on('click', '*', select_suggestion);

function select_suggestion(e) {
  cj(".suggestion").removeClass('suggestion-selected');
  let suggestion = cj(e.target).closest(".suggestion");
  suggestion.addClass('suggestion-selected');
  let button = suggestion.find("input[name=selected_suggestion]");
  button.prop('checked', true);
}


function analysePayment() {
  var reload_regex = new RegExp("(execute=)[0-9]+", 'ig');

  if (cj("#analyseButton").hasClass('disabled')) return;

  // disable ALL buttons
  cj(".button").addClass('disabled');
  cj(".button").attr("onclick","");

  // remove old suggestions
  cj(".suggestions").remove();
  cj("#generating_suggestions").show();

  // show busy indicator

  // AJAX call the analyser
  var query = {'q': 'civicrm/ajax/rest', 'sequential': 1};
  // set the list or s_list parameter depending on the page mode
  query['list'] = "{/literal}{$payment->id}{literal}";
  CRM.api('BankingTransaction', 'analyselist', query,
    {success: function(data) {
        if (!data['is_error']) {
          // remove 'execute' bit from URL before reload
          var newURL = window.location.href.replace(reload_regex, '');
          if (window.location.href == newURL) {
            window.location.reload(false);
          } else {
            window.location = newURL;
          }
        } else {
          cj('<div title="{/literal}{ts domain='org.project60.banking'}Error{/ts}{literal}"><span class="ui-icon ui-icon-alert" style="float:left;"></span>' + data['error_message'] + '</div>').dialog({
            modal: true,
            buttons: {
              Ok: function() {
                window.location = window.location.href.replace(reload_regex, '');
              }
            }
          });
        }
      }
    }
  );
}

/**
 * common function to bring CiviCRM 4.5+ popups into the game
 */
function banking_open_link(dirty_link, replacements, asPopup) {
  // "clean" the link
  var link = cj("<div/>").html(dirty_link).text();

  // replace the tokens
  for (var token in replacements) {
    link = link.replace(token, replacements[token]);
  }

  if (asPopup && {/literal}{$popups_allowed}{literal}) {
    // popup requested and possible => do it!
    var popup_node = cj('<a href="' + link + '" class="crm-popup" />');
    popup_node.click(CRM.popup); // add handler
    popup_node.click(); // execute handler
  } else {
    // open in an extra tab
    window.open(link, "_blank");
  }
}
</script>
{/literal}