def skydropx
  payload = JSON.parse(request.body.read, symbolize_names: true)

  ProcessSkydropxWebhookJob.perform_later(payload)

  head :ok
end
