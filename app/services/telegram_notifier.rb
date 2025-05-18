require 'telegram/bot'
require 'dotenv'
Dotenv.load

class TelegramNotifier
  def initialize(user)
    @user = user
  end

  def notify(text)
    return unless @user&.telegram_id.present?
    send_telegramm(@user.telegram_id, text)
  end

  private

  def send_telegramm(telegram_id, message)
    # Здесь ваша реальная отправка через Telegram Bot API или другую обёртку
    token = ENV['TELEGRAM_TOKEN']
    begin
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: telegram_id.to_i, text: message)
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      Rails.logger.error "Telegram error: #{e.message}"
    end
  end
end