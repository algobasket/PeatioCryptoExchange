module Private
  class AssetsController < BaseController
    skip_before_action :auth_member!, only: [:index]

    def index
      @proofs = {}
      @accounts = {}
      @currencies = []

      Currency.all.sort_by(&:code).map do |currency|
        code = currency.code.to_sym
        @proofs[currency.code] = Proof.current code
        @currencies.push ({
            code: currency.code,
            coin: currency.coin?
        })
        if current_user
          @accounts[currency.code] = current_user.accounts.with_currency(code).first
        end
      end
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
