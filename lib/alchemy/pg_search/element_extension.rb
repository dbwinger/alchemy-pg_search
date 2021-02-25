Alchemy::Element.class_eval do
  include PgSearch

  pg_search_scope :full_text_search,
    associated_against: {
      essence_texts:     :body,
      essence_richtexts: :stripped_body,
      essence_pictures:  :caption
    },
    using: {
      tsearch: {prefix: true}
    }

  has_many :essence_texts,
    -> { where(alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssenceText',
    source_type: 'Alchemy::EssenceText',
    through: :contents,
    source: :essence

  has_many :essence_richtexts,
    -> { where(alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssenceRichtext',
    source_type: 'Alchemy::EssenceRichtext',
    through: :contents,
    source: :essence

  has_many :essence_pictures,
    -> { where(alchemy_elements: {public: true}) },
    class_name: 'Alchemy::EssencePicture',
    source_type: 'Alchemy::EssencePicture',
    through: :contents,
    source: :essence

  has_many :searchable_contents,
    -> { where(essence_type: ['Alchemy::EssenceText', 'Alchemy::EssenceRichtext', 'Alchemy::EssencePicture']) },
    class_name: 'Alchemy::Content',
    source: :contents

end
