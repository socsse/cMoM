#
# Add your destination definitions here
# can also be used to configure filters, and processor groups
#
ActiveMessaging::Gateway.define do |s|

  #s.destination :orders, '/queue/Orders'
  #s.filter :some_filter, :only=>:orders
  #s.processor_group :group1, :order_processor

  case Rails.env
    when 'production'
      s.destination :job_status_queue, 'CMoMJobStatusQueue'
      s.destination :job_todo_queue,   'CMoMJobTodoQueue'
    when 'test'
      s.destination :job_status_queue, '/queue/CMoMJobStatusQueue'
      s.destination :job_todo_queue,   '/queue/CMoMJobTodoQueue'
    else
      s.destination :job_status_queue, '/queue/CMoMJobStatusQueue'
      s.destination :job_todo_queue,   '/queue/CMoMJobTodoQueue'
    end
end
