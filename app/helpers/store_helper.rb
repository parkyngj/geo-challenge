class StoreHelper

  def find_store(input_address)
    @input_address = GeocoderService.address_info(Geocoder.search(input_address))
    return if @input_address.nil?
    get_closest
  end

  private

  def get_closest
    input_coords = [@input_address['lat'], @input_address['lng']]
    closest_store = Store.all.first
    closest_distance = Haversine.distance(input_coords,
                                          [closest_store.latitude, closest_store.longitude].map(&:to_f)
                                          ).to_miles

    Store.all.each do |store|
      distance = Haversine.distance(input_coords,
                                    [store.latitude, store.longitude].map(&:to_f)
                                    ).to_miles
      if closest_distance > distance
        closest_store = store
        closest_distance = distance
      end
    end

    closest_store
  end

end
