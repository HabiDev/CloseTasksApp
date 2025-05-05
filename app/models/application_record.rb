class ApplicationRecord < ActiveRecord::Base
  require 'telegram/bot'
  require 'dotenv'
  Dotenv.load

  primary_abstract_class

  def send_telegramm(chat_id, message)
    token = ENV['TELEGRAM_TOKEN']
    begin
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: chat_id.to_i, text: message)
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      Rails.logger.error "Telegram error: #{e.message}"
    end
  end

  def human_enum_name(enum_name, enum_value)
    enum_i18n_key = enum_name.to_s.pluralize
    I18n.t("activerecord.enums.#{model_name.i18n_key}.#{enum_i18n_key}.#{enum_value}")
  end

end
