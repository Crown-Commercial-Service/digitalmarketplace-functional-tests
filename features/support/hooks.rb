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

Before('@with-production-buyer-user') do
  user_details = {
    "emailAddress" => dm_production_buyer_user_email,
    "name" => dm_production_buyer_user_name,
    "password" => dm_production_buyer_user_password,
    "role" => "buyer",
  }
  @production_buyer_user = user_details.merge(ensure_user_exists(user_details))
end

Before('@with-production-admin-user') do
  user_details = {
    "emailAddress" => dm_production_admin_user_email,
    "name" => dm_production_admin_user_name,
    "password" => dm_production_admin_user_password,
    "role" => "admin",
  }
  @production_admin_user = user_details.merge(ensure_user_exists(user_details))
end

Before('@with-production-admin-ccs-category-user') do
  user_details = {
    "emailAddress" => dm_production_admin_ccs_category_user_email,
    "name" => dm_production_admin_ccs_category_user_name,
    "password" => dm_production_admin_ccs_category_user_password,
    "role" => "admin-ccs-category",
  }
  @production_admin_ccs_category_user = user_details.merge(ensure_user_exists(user_details))
end

Before('@with-production-admin-ccs-sourcing-user') do
  user_details = {
    "emailAddress" => dm_production_admin_ccs_sourcing_user_email,
    "name" => dm_production_admin_ccs_sourcing_user_name,
    "password" => dm_production_admin_ccs_sourcing_user_password,
    "role" => "admin-ccs-sourcing",
  }
  @production_admin_ccs_sourcing_user = user_details.merge(ensure_user_exists(user_details))
end
