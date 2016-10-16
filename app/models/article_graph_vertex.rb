class ArticleGraphVertex < ActiveRecord::Base
  belongs_to :article_1, class_name: 'Article'
  belongs_to :article_2, class_name: 'Article'
end
