module CoinMarketCap

using PyCall, DataFrames

export Market, ticker, ticker_by_cap

@pyimport coinmarketcap as coin

Market() = coin.Market()
ticker(market; limit=100) = market[:ticker](limit=limit)
function ticker_by_cap(::Type{DataFrame}, market, thresh=5e9; limit::Int=100) 
    df = DataFrame([String, Float64], [:symbol, :market_cap], 0)
    resp = ticker(market; limit=limit)
    for a in resp
        cap = parse(Float64, a["market_cap_usd"])
        if cap >= thresh 
            push!(df, [a["symbol"], cap])
        end
    end
    df
end

end # module
