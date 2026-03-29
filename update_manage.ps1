$content = Get-Content apuasc-war/web/Pages/Receptionist/ManageCustomers.jsp -Raw

$oldRow = '(?s)<td><%= address %></td>\s*<td>\s*<div class="action-buttons">\s*<button class="btn-small btn-view".*?</button>\s*<button class="btn-small btn-edit".*?</button>'
$newRow = '<td><%= origin %></td>
                          <td>
                              <div class="action-buttons">
                                  <a href="EditCustomer.jsp?id=<%= customer.getId() %>" class="btn-small btn-edit" style="text-decoration:none; display:inline-block; text-align:center;">Update</a>'
$content = $content -replace $oldRow, $newRow

$content = $content -replace '(?s)<!-- View Modal -->.*?</script>', '</script>'

$content | Set-Content apuasc-war/web/Pages/Receptionist/ManageCustomers.jsp
