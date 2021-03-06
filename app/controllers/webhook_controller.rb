class WebhookController < ApplicationController
  #Lineからのcallbackか認証
  protect_from_forgery with: :null_session

  CHANNEL_SECRET = ENV['CHANNEL_SECRET']
  OUTBOUND_PROXY = ENV['OUTBOUND_PROXY']
  CHANNEL_ACCESS_TOKEN = ENV['CHANNEL_ACCESS_TOKEN']

  def callback
    unless is_validate_signature
      render :nothing => true, status: 470
    end

    event = params["events"][0]
    event_type = event["type"]
    replyToken = event["replyToken"]

    flug = 0;
    case event_type
    when "beacon" then
      # input_text = Phrase.where( 'id >= ?', rand(Phrase.first.id..Phrase.last.id) ).first.word
      flug = 1;
      output_text = "美人接近中！！(http://hacklog.jp/works/51384)"
    when "message" then
      flug = 2;
      time = Time.now.in_time_zone('Tokyo').to_s
      input_text = event["message"]["text"]
      output_text = input_text
    end


    client = LineClient.new(CHANNEL_ACCESS_TOKEN, OUTBOUND_PROXY)
    res = client.reply(replyToken, output_text)

    if res.status == 200
      logger.info({success: res})
    else
      logger.info({fail: res})
    end

    render :nothing => true, status: :ok
  end

  # def reply(replyToken, text)
  #
  #   messages = [
  #     {
  #       "type" => "text" ,
  #       "text" => text
  #     },
  #     {
  #       "type" => "text" ,
  #       "text" => text
  #     }
  #
  #   ]
  #
  #   body = {
  #     "replyToken" => replyToken ,
  #     "messages" => messages
  #   }
  #   post('/v2/bot/message/reply', body.to_json)
  # end


  private
  # verify access from LINE
  def is_validate_signature
    signature = request.headers["X-LINE-Signature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
