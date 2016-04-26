class Utils
  REGEX_FIELD = /[a-zA-Z0-9]{3,20}/
  REGEX_EMAIL = /.+@.+/

  def same_password?(password, confirm_password)
    password == confirm_password
  end

  def legit_format?(field, is_email)
    is_email ? field == REGEX_EMAIL.match(field).to_s : field == REGEX_FIELD.match(field).to_s
  end
end
