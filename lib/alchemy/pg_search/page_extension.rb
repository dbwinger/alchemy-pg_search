Alchemy::Page.class_eval do
	include PgSearch

	# Enable Postgresql full text indexing.
	#
	pg_search_scope :full_text_search, against: {
			meta_description: 'B',
			meta_keywords:    'B',
			title:            'B',
			name:             'A'
		},
		associated_against: {
			essence_texts:     :body,
			essence_richtexts: :stripped_body,
			essence_pictures:  :caption
		},
		using: {
			tsearch: {prefix: true}
		}

	has_many :descendent_elements,
		-> { order(:position).unfixed.available },
		class_name: 'Alchemy::Element'
				
	has_many :descendent_contents,
		through: :descendent_elements,
		class_name: 'Alchemy::Content',
		source: :contents

	# has_many :searchable_essence_texts,
	# 	-> { where(searchable: true, alchemy_elements: {public: true}) },
	# 	class_name: 'Alchemy::EssenceText',
	# 	source_type: 'Alchemy::EssenceText',
	# 	through: :descendent_contents,
	# 	source: :essence

	# has_many :searchable_essence_richtexts,
	# 	-> { where(searchable: true, alchemy_elements: {public: true}) },
	# 	class_name: 'Alchemy::EssenceRichtext',
	# 	source_type: 'Alchemy::EssenceRichtext',
	# 	through: :descendent_contents,
	# 	source: :essence

	# has_many :searchable_essence_pictures,
	# 	-> { where(searchable: true, alchemy_elements: {public: true}) },
	# 	class_name: 'Alchemy::EssencePicture',
	# 	source_type: 'Alchemy::EssencePicture',
	# 	through: :descendent_contents,
	# 	source: :essence

	has_many :essence_texts,
		-> { where(alchemy_elements: {public: true}) },
		class_name: 'Alchemy::EssenceText',
		source_type: 'Alchemy::EssenceText',
		through: :descendent_contents,
		source: :essence

	has_many :essence_richtexts,
		-> { where(alchemy_elements: {public: true}) },
		class_name: 'Alchemy::EssenceRichtext',
		source_type: 'Alchemy::EssenceRichtext',
		through: :descendent_contents,
		source: :essence

	has_many :essence_pictures,
		-> { where(alchemy_elements: {public: true}) },
		class_name: 'Alchemy::EssencePicture',
		source_type: 'Alchemy::EssencePicture',
		through: :descendent_contents,
		source: :essence

	def element_search_results(query)
		descendent_elements.full_text_search(query)
	end
end
