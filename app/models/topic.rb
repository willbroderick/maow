class Topic < ActiveRecord::Base
  belongs_to :industry
  has_many :topic_rules, dependent: :destroy

  def articles
    sql = ''
    topic_rules.all.each do |rule|
      if rule.has_entity_or?
        if sql.length == 0
          sql << '('
        else
          sql << 'OR '
        end
        sql << rule.to_sql
      end
    end
    sql << ')' if sql.length > 0
    topic_rules.all.each do |rule|
      if !rule.has_entity_or?
        sql << 'AND ' if sql.length > 0
        sql << rule.to_sql
      end
    end
    industry.articles.where(sql)
  end
end
