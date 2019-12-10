FACTORY = RGeo::Geographic.simple_mercator_factory

RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  config.default = FACTORY.projection_factory
end
