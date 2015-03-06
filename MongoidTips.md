## MONGOID TIPS

Remove unnecessary properties from documents
Topic.each { |topic| topic.unset(:type) }

Fonte:
https://coderwall.com/p/wcx4pq/mongoid-remove-unnecessary-properties-from-documents

Slugs
mongoid-slug gem
http://artsy.github.io/blog/2012/11/22/friendly-urls-with-mongoid-slug/


Rename Collection
session = Mongoid.default_session
collection = session.collections.select {|c| c if c.name.eql?('collection_name')}.first
c.rename 'new_collection_name'


Rename attributes of existing documents

SomeModel.all.each {|m| m.rename :old_attribute_name, :new_attribute_name }

ParentModel.all.each {|m| m.rename :old_embedded_association_name, :new_embedded_association_name }
