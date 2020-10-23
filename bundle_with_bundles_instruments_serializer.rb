# frozen_string_literal: true
module Notation
  class BundleWithBundlesInstrumentsSerializer
    include JSONAPI::Serializer
    include PlayUrlConcern

    set_type 'bundles'
    set_key_transform :dash

    attributes :title,
               :sm_classic_id,
               :music_xml_file_type,
               :score_type,
               :updated_at

    attribute :practice_play_url do |object|
      play_bundle_url(object, object.bundles_instruments.first)
    end

    attribute :music_file_url do |object|
      music_url(object)
    end

    attribute :music_xml_url do |object|
      music_url(object)
    end

    has_many :bundles_instruments, serializer: Notation::BundlesInstrumentSerializer

    has_many :movements, serializer: Notation::MovementSerializer

    def self.music_url(object)
      if Rails.env.development? && !Dragonfly.app.datastore.is_a?(Dragonfly::S3DataStore)
        object.music_xml.url
      else
        object.music_xml.remote_url(expires: 10.minutes.from_now)
      end
    end
  end
end
