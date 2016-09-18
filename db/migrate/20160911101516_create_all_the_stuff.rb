class CreateAllTheStuff < ActiveRecord::Migration
  def change
    # e.g. news, tech, games, comedy-writers
    create_table :industries do |t|
      t.string :name, null: false
      t.text :description
    end

    # e.g. Daily Mail, The Guardian
    create_table :sources do |t|
      t.integer :industry_id, null: false
      t.string :name, null: false
      t.text :svg_icon
      t.string :colour, null: false
      t.string :rss_url, null: false
      t.datetime :last_fetched
    end

    # e.g. political leaning L-R, popularity, reputation
    create_table :biases do |t|
      t.integer :industry_id, null: false
      t.string :name, null: false
      t.text :description
      t.string :from_colour, null: false
      t.string :to_colour, null: false
    end

    # e.g. Daily Mail, right wing, 100%
    create_table :source_bias_levels do |t|
      t.integer :source_id, null: false
      t.integer :bias_id, null: false
      t.integer :level, null: false
    end

    # e.g. Corbyn 2016, Nuclear Proliferation
    create_table :topics do |t|
      t.integer :industry_id, null: false
      t.string :name, null: false
    end

    # e.g. contains 'corbyn' + published after 4th July
    create_table :topic_rules do |t|
      t.integer :topic_id, null: false
      t.integer :logic, null: false, default: 0
      t.integer :value
    end

    # e.g. An Actual News Article
    create_table :articles do |t|
      t.integer :source_id, null: false
      t.string :title, null: false
      t.text :summary
      t.datetime :published, null: false
      t.text :uid, null: false
    end

    # e.g. corbyn, syria, 'queen' (without a 'the'), 'the queen', birmingham
    create_table :entities do |t|
      t.integer :industry_id, null: false
      t.string :entity, null: false
    end

    # e.g. Article 1 contains 'corbyn'
    create_table :article_entities do |t|
      t.integer :article_id, null: false
      t.integer :entity_id, null: false
    end
  end
end
