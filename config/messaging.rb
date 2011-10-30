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
      s.destination :job_queue, 'CMoMJobQueue'
    when 'test'
      s.destination :job_queue, '/queue/CMoMJobQueue'
    else
      s.destination :job_queue, '/queue/CMoMJobQueue'
    end

end
