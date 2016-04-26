require_relative "../../lib/utils"

describe Utils do
  utils = Utils.new

  context "password validation" do
    it "returns true is the passwords are the same" do
      password = "password123"
      confirm_password= "password123"

      expect(utils.same_password?(password, confirm_password)).to be true
    end

    it "returns false is the passwords are not the same" do
      password = "password123"
      confirm_password= "password12345"

      expect(utils.same_password?(password, confirm_password)).to be false
    end
  end

  context "field validation" do
    it "returns true for valid fields" do
      fields = %w(12345 ab56ZJ XYZZZ abk 90kkjAa)

      fields.each do |field|
        expect(utils.legit_format?(field, false)).to be true
      end
    end

    it "returns false for invalid fields" do
      fields = %w(12-345 @ w90.98aa 09a/Ad 12"z#A)

      fields.each do |field|
        expect(utils.legit_format?(field, false)).to be false
      end
    end
  end

  context "email field validation" do
    it "returns true for valid email fields" do
      fields = %w(123@123.com chris@gmail.com Ab5@hotmail.co.uk)

      fields.each do |field|
        expect(utils.legit_format?(field, true)).to be true
      end
    end

    it "returns false for invalid email fields" do
      fields = %w(chris.com @gmail.uk pizza_box@)

      fields.each do |field|
        expect(utils.legit_format?(field, true)).to be false
      end
    end
  end
end
