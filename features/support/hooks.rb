Before('@with-production-supplier-user') do
  user_details = {
    "emailAddress" => dm_production_supplier_user_email,
    "name" => dm_production_supplier_user_name,
    "password" => dm_production_supplier_user_password,
    "role" => "supplier",
    "supplierId" => dm_production_supplier_user_supplier_id,
  }
  @production_supplier_user = user_details.merge(ensure_user_exists(user_details))
end
