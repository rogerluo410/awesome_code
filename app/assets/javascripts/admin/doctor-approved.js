$(document).ready(function() {
  $("[name='approved-switch-checkbox']").bootstrapSwitch();

  $('.modal').on('hidden.bs.modal', function () {
    $("[name='approved-switch-checkbox']").bootstrapSwitch();
  })

  $("[name='approved-switch-checkbox']").on('switchChange.bootstrapSwitch', function(){
    var id = $(this).attr("data-id")
    var state = $(this).is(':checked')

    $.ajax({
      type: "patch",
      url: "/admin/doctors/"+id+"/toggle_approved",
      dataType: 'json',
      data: { approved: state },
      success: function(){
      },
      errors: function(){
      },
    })
  })
})

