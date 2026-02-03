defmodule Taapi.Indicators do
  @moduledoc """
  All 208 Taapi.io indicators with auto-generated functions and metadata.

  This module uses the `indicator` macro to define indicators. Each definition
  generates both the API function and discovery metadata.

  ## Usage

      # Call an indicator
      Taapi.Indicators.rsi(api_key: "key", exchange: "binance", symbol: "BTC/USDT", interval: "1d")

      # Discovery
      Taapi.Indicators.all_indicators()  # List all with metadata
      Taapi.Indicators.describe(:rsi)    # Single indicator details

  Note: Most users should use the `Taapi` module which delegates to this one.
  """

  use Taapi.Indicator

  # =============================================================================
  # Pattern Recognition (61 indicators)
  # =============================================================================

  indicator(:"2crows", endpoint: "2crows", description: "Two Crows", categories: [:pattern])
  indicator(:"3blackcrows", endpoint: "3blackcrows", description: "Three Black Crows", categories: [:pattern])
  indicator(:"3inside", endpoint: "3inside", description: "Three Inside Up/Down", categories: [:pattern])
  indicator(:"3linestrike", endpoint: "3linestrike", description: "Three-Line Strike", categories: [:pattern])
  indicator(:"3outside", endpoint: "3outside", description: "Three Outside Up/Down", categories: [:pattern])
  indicator(:"3starsinsouth", endpoint: "3starsinsouth", description: "Three Stars In The South", categories: [:pattern])

  indicator(:"3whitesoldiers",
    endpoint: "3whitesoldiers",
    description: "Three Advancing White Soldiers",
    categories: [:pattern]
  )

  indicator(:abandonedbaby, endpoint: "abandonedbaby", description: "Abandoned Baby", categories: [:pattern])
  indicator(:advanceblock, endpoint: "advanceblock", description: "Advance Block", categories: [:pattern])
  indicator(:belthold, endpoint: "belthold", description: "Belt-hold", categories: [:pattern])
  indicator(:breakaway, endpoint: "breakaway", description: "Breakaway", categories: [:pattern])
  indicator(:closingmarubozu, endpoint: "closingmarubozu", description: "Closing Marubozu", categories: [:pattern])

  indicator(:concealbabyswall,
    endpoint: "concealbabyswall",
    description: "Concealing Baby Swallow",
    categories: [:pattern]
  )

  indicator(:counterattack, endpoint: "counterattack", description: "Counterattack", categories: [:pattern])
  indicator(:darkcloudcover, endpoint: "darkcloudcover", description: "Dark Cloud Cover", categories: [:pattern])
  indicator(:doji, endpoint: "doji", description: "Doji", categories: [:pattern])
  indicator(:dojistar, endpoint: "dojistar", description: "Doji Star", categories: [:pattern])
  indicator(:dragonflydoji, endpoint: "dragonflydoji", description: "Dragonfly Doji", categories: [:pattern])
  indicator(:engulfing, endpoint: "engulfing", description: "Engulfing Pattern", categories: [:pattern])
  indicator(:eveningdojistar, endpoint: "eveningdojistar", description: "Evening Doji Star", categories: [:pattern])
  indicator(:eveningstar, endpoint: "eveningstar", description: "Evening Star", categories: [:pattern])

  indicator(:gapsidesidewhite,
    endpoint: "gapsidesidewhite",
    description: "Up/Down-gap side-by-side white lines",
    categories: [:pattern]
  )

  indicator(:gravestonedoji, endpoint: "gravestonedoji", description: "Gravestone Doji", categories: [:pattern])
  indicator(:hammer, endpoint: "hammer", description: "Hammer", categories: [:pattern])
  indicator(:hangingman, endpoint: "hangingman", description: "Hanging Man", categories: [:pattern])
  indicator(:harami, endpoint: "harami", description: "Harami Pattern", categories: [:pattern])
  indicator(:haramicross, endpoint: "haramicross", description: "Harami Cross Pattern", categories: [:pattern])
  indicator(:highwave, endpoint: "highwave", description: "High-Wave Candle", categories: [:pattern])
  indicator(:hikkake, endpoint: "hikkake", description: "Hikkake Pattern", categories: [:pattern])
  indicator(:hikkakemod, endpoint: "hikkakemod", description: "Modified Hikkake Pattern", categories: [:pattern])
  indicator(:homingpigeon, endpoint: "homingpigeon", description: "Homing Pigeon", categories: [:pattern])
  indicator(:identical3crows, endpoint: "identical3crows", description: "Identical Three Crows", categories: [:pattern])
  indicator(:inneck, endpoint: "inneck", description: "In-Neck Pattern", categories: [:pattern])
  indicator(:invertedhammer, endpoint: "invertedhammer", description: "Inverted Hammer", categories: [:pattern])
  indicator(:kicking, endpoint: "kicking", description: "Kicking", categories: [:pattern])
  indicator(:kickingbylength, endpoint: "kickingbylength", description: "Kicking by length", categories: [:pattern])
  indicator(:ladderbottom, endpoint: "ladderbottom", description: "Ladder Bottom", categories: [:pattern])
  indicator(:longleggeddoji, endpoint: "longleggeddoji", description: "Long Legged Doji", categories: [:pattern])
  indicator(:longline, endpoint: "longline", description: "Long Line Candle", categories: [:pattern])
  indicator(:marubozu, endpoint: "marubozu", description: "Marubozu", categories: [:pattern])
  indicator(:matchinglow, endpoint: "matchinglow", description: "Matching Low", categories: [:pattern])
  indicator(:mathold, endpoint: "mathold", description: "Mat Hold", categories: [:pattern])
  indicator(:morningdojistar, endpoint: "morningdojistar", description: "Morning Doji Star", categories: [:pattern])
  indicator(:morningstar, endpoint: "morningstar", description: "Morning Star", categories: [:pattern])
  indicator(:onneck, endpoint: "onneck", description: "On-Neck Pattern", categories: [:pattern])
  indicator(:piercing, endpoint: "piercing", description: "Piercing Pattern", categories: [:pattern])
  indicator(:rickshawman, endpoint: "rickshawman", description: "Rickshaw Man", categories: [:pattern])

  indicator(:risefall3methods,
    endpoint: "risefall3methods",
    description: "Rising/Falling Three Methods",
    categories: [:pattern]
  )

  indicator(:separatinglines, endpoint: "separatinglines", description: "Separating Lines", categories: [:pattern])
  indicator(:shootingstar, endpoint: "shootingstar", description: "Shooting Star", categories: [:pattern])
  indicator(:shortline, endpoint: "shortline", description: "Short Line Candle", categories: [:pattern])
  indicator(:spinningtop, endpoint: "spinningtop", description: "Spinning Top", categories: [:pattern])
  indicator(:stalledpattern, endpoint: "stalledpattern", description: "Stalled Pattern", categories: [:pattern])
  indicator(:sticksandwich, endpoint: "sticksandwich", description: "Stick Sandwich", categories: [:pattern])
  indicator(:takuri, endpoint: "takuri", description: "Takuri", categories: [:pattern])
  indicator(:tasukigap, endpoint: "tasukigap", description: "Tasuki Gap", categories: [:pattern])
  indicator(:thrusting, endpoint: "thrusting", description: "Thrusting Pattern", categories: [:pattern])
  indicator(:tristar, endpoint: "tristar", description: "Tristar Pattern", categories: [:pattern])
  indicator(:unique3river, endpoint: "unique3river", description: "Unique 3 River", categories: [:pattern])
  indicator(:upsidegap2crows, endpoint: "upsidegap2crows", description: "Upside Gap Two Crows", categories: [:pattern])

  indicator(:xsidegap3methods,
    endpoint: "xsidegap3methods",
    description: "Upside/Downside Gap Three Methods",
    categories: [:pattern]
  )

  # =============================================================================
  # Momentum Indicators
  # =============================================================================

  indicator(:adx, endpoint: "adx", description: "Average Directional Movement Index", categories: [:momentum])
  indicator(:adxr, endpoint: "adxr", description: "Average Directional Movement Index Rating", categories: [:momentum])
  indicator(:ao, endpoint: "ao", description: "Awesome Oscillator", categories: [:momentum])
  indicator(:apo, endpoint: "apo", description: "Absolute Price Oscillator", categories: [:momentum])
  indicator(:aroon, endpoint: "aroon", description: "Aroon", categories: [:momentum])
  indicator(:aroonosc, endpoint: "aroonosc", description: "Aroon Oscillator", categories: [:momentum])
  indicator(:bop, endpoint: "bop", description: "Balance Of Power", categories: [:momentum])
  indicator(:cci, endpoint: "cci", description: "Commodity Channel Index", categories: [:momentum])
  indicator(:cmo, endpoint: "cmo", description: "Chande Momentum Oscillator", categories: [:momentum, :oscillator])
  indicator(:dx, endpoint: "dx", description: "Directional Movement Index", categories: [:momentum, :oscillator])
  indicator(:macd, endpoint: "macd", description: "Moving Average Convergence Divergence", categories: [:momentum])
  indicator(:macdext, endpoint: "macdext", description: "MACD with controllable MA type", categories: [:momentum])

  indicator(:marketfi,
    endpoint: "marketfi",
    description: "Market Facilitation Index",
    categories: [:momentum, :trend, :volume]
  )

  indicator(:mfi, endpoint: "mfi", description: "Money Flow Index", categories: [:momentum, :oscillator])
  indicator(:minus_di, endpoint: "minus_di", description: "Minus Directional Indicator", categories: [:momentum])
  indicator(:minus_dm, endpoint: "minus_dm", description: "Minus Directional Movement", categories: [:momentum])
  indicator(:mom, endpoint: "mom", description: "Momentum", categories: [:momentum])
  indicator(:pd, endpoint: "pd", description: "Price Direction", categories: [:momentum, :oscillator])
  indicator(:plus_di, endpoint: "plus_di", description: "Plus Directional Indicator", categories: [:momentum])
  indicator(:plus_dm, endpoint: "plus_dm", description: "Plus Directional Movement", categories: [:momentum])
  indicator(:ppo, endpoint: "ppo", description: "Percentage Price Oscillator", categories: [:momentum, :oscillator])
  indicator(:roc, endpoint: "roc", description: "Rate of Change", categories: [:momentum, :oscillator, :trend])
  indicator(:rocp, endpoint: "rocp", description: "Rate of Change Percentage", categories: [:momentum])
  indicator(:rocr, endpoint: "rocr", description: "Rate of Change Ratio", categories: [:momentum])
  indicator(:rocr100, endpoint: "rocr100", description: "Rate of Change Ratio 100 scale", categories: [:momentum])
  indicator(:rsi, endpoint: "rsi", description: "Relative Strength Index", categories: [:momentum, :oscillator])
  indicator(:rvgi, endpoint: "rvgi", description: "Relative Vigor Index", categories: [:momentum, :oscillator])

  indicator(:squeeze,
    endpoint: "squeeze",
    description: "Squeeze Momentum Indicator",
    categories: [:momentum, :volatility]
  )

  indicator(:stc, endpoint: "stc", description: "Schaff Trend Cycle", categories: [:momentum, :oscillator])
  indicator(:stoch, endpoint: "stoch", description: "Stochastic", categories: [:momentum, :oscillator])
  indicator(:stochf, endpoint: "stochf", description: "Stochastic Fast", categories: [:momentum, :oscillator])
  indicator(:stochrsi, endpoint: "stochrsi", description: "Stochastic RSI", categories: [:momentum, :oscillator])
  indicator(:supertrend, endpoint: "supertrend", description: "Supertrend", categories: [:momentum, :trend])
  indicator(:tdsequential, endpoint: "tdsequential", description: "Tom DeMark Sequential", categories: [:momentum])
  indicator(:trix, endpoint: "trix", description: "TRIX", categories: [:momentum, :oscillator])
  indicator(:ultosc, endpoint: "ultosc", description: "Ultimate Oscillator", categories: [:momentum, :oscillator])
  indicator(:wad, endpoint: "wad", description: "Williams Accumulation/Distribution", categories: [:momentum])
  indicator(:willr, endpoint: "willr", description: "Williams %R", categories: [:momentum])

  # =============================================================================
  # Oscillators
  # =============================================================================

  indicator(:accosc, endpoint: "accosc", description: "Accelerator Oscillator", categories: [:oscillator])
  indicator(:chop, endpoint: "chop", description: "Choppiness Index", categories: [:oscillator])
  indicator(:coppockcurve, endpoint: "coppockcurve", description: "Coppock Curve", categories: [:oscillator, :overlap])
  indicator(:dm, endpoint: "dm", description: "Directional Movement", categories: [:oscillator, :trend])
  indicator(:dmi, endpoint: "dmi", description: "Directional Movement Index", categories: [:oscillator, :trend])
  indicator(:dpo, endpoint: "dpo", description: "Detrended Price Oscillator", categories: [:oscillator])
  indicator(:eom, endpoint: "eom", description: "Ease of Movement", categories: [:oscillator])
  indicator(:fosc, endpoint: "fosc", description: "Forecast Oscillator", categories: [:oscillator])
  indicator(:kvo, endpoint: "kvo", description: "Klinger Volume Oscillator", categories: [:oscillator])
  indicator(:vosc, endpoint: "vosc", description: "Volume Oscillator", categories: [:oscillator, :volume])

  # =============================================================================
  # Overlap Studies (Moving Averages, Bands, etc.)
  # =============================================================================

  indicator(:accbands, endpoint: "accbands", description: "Acceleration Bands", categories: [:overlap])
  indicator(:bbands, endpoint: "bbands", description: "Bollinger Bands", categories: [:overlap, :trend, :volatility])
  indicator(:dema, endpoint: "dema", description: "Double Exponential Moving Average", categories: [:overlap])

  indicator(:donchianchannels,
    endpoint: "donchianchannels",
    description: "Donchian Channels",
    categories: [:overlap, :trend, :volatility]
  )

  indicator(:ema, endpoint: "ema", description: "Exponential Moving Average", categories: [:overlap])

  indicator(:fibonacciretracement,
    endpoint: "fibonacciretracement",
    description: "Fibonacci Retracement",
    categories: [:overlap]
  )

  indicator(:hma, endpoint: "hma", description: "Hull Moving Average", categories: [:overlap])

  indicator(:ht_trendline,
    endpoint: "ht_trendline",
    description: "Hilbert Transform - Instantaneous Trendline",
    categories: [:overlap]
  )

  indicator(:ichimoku, endpoint: "ichimoku", description: "Ichimoku Cloud", categories: [:momentum, :overlap])
  indicator(:kama, endpoint: "kama", description: "Kaufman Adaptive Moving Average", categories: [:overlap])
  indicator(:kdj, endpoint: "kdj", description: "KDJ", categories: [:overlap])

  indicator(:keltnerchannels,
    endpoint: "keltnerchannels",
    description: "Keltner Channels",
    categories: [:overlap, :volatility]
  )

  indicator(:ma, endpoint: "ma", description: "Moving Average", categories: [:overlap])
  indicator(:mama, endpoint: "mama", description: "MESA Adaptive Moving Average", categories: [:overlap])
  indicator(:midpoint, endpoint: "midpoint", description: "MidPoint over period", categories: [:overlap])
  indicator(:midprice, endpoint: "midprice", description: "Midpoint Price over period", categories: [:overlap])

  indicator(:pivotpoints,
    endpoint: "pivotpoints",
    description: "Pivot Points",
    categories: [:overlap, :support_resistance, :trend]
  )

  indicator(:psar, endpoint: "psar", description: "Parabolic SAR", categories: [:overlap, :trend])
  indicator(:sma, endpoint: "sma", description: "Simple Moving Average", categories: [:overlap])
  indicator(:smma, endpoint: "smma", description: "Smoothed Moving Average", categories: [:overlap, :trend])
  indicator(:t3, endpoint: "t3", description: "Triple Exponential Moving Average (T3)", categories: [:overlap])
  indicator(:tema, endpoint: "tema", description: "Triple Exponential Moving Average", categories: [:overlap])
  indicator(:trima, endpoint: "trima", description: "Triangular Moving Average", categories: [:overlap])
  indicator(:vidya, endpoint: "vidya", description: "Variable Index Dynamic Average", categories: [:overlap])
  indicator(:vwap, endpoint: "vwap", description: "Volume Weighted Average Price", categories: [:overlap, :volume])
  indicator(:vwma, endpoint: "vwma", description: "Volume Weighted Moving Average", categories: [:overlap, :volume])
  indicator(:wilders, endpoint: "wilders", description: "Wilders Smoothing", categories: [:overlap])

  indicator(:williamsalligator,
    endpoint: "williamsalligator",
    description: "Williams Alligator",
    categories: [:overlap, :trend]
  )

  indicator(:wma, endpoint: "wma", description: "Weighted Moving Average", categories: [:overlap])
  indicator(:zlema, endpoint: "zlema", description: "Zero-Lag Exponential Moving Average", categories: [:overlap])

  # =============================================================================
  # Volatility
  # =============================================================================

  indicator(:atr, endpoint: "atr", description: "Average True Range", categories: [:volatility])
  indicator(:bbw, endpoint: "bbw", description: "Bollinger Bands Width", categories: [:volatility])
  indicator(:mass, endpoint: "mass", description: "Mass Index", categories: [:volatility])
  indicator(:natr, endpoint: "natr", description: "Normalized Average True Range", categories: [:volatility])
  indicator(:stddev, endpoint: "stddev", description: "Standard Deviation", categories: [:statistic, :volatility])

  indicator(:volatility,
    endpoint: "volatility",
    description: "Annualized Historical Volatility",
    categories: [:volatility]
  )

  # =============================================================================
  # Volume
  # =============================================================================

  indicator(:ad, endpoint: "ad", description: "Chaikin A/D Line", categories: [:volume])
  indicator(:adosc, endpoint: "adosc", description: "Chaikin A/D Oscillator", categories: [:volume])
  indicator(:cmf, endpoint: "cmf", description: "Chaikin Money Flow", categories: [:volume])
  indicator(:nvi, endpoint: "nvi", description: "Negative Volume Index", categories: [:volume])
  indicator(:obv, endpoint: "obv", description: "On Balance Volume", categories: [:volume])
  indicator(:pvi, endpoint: "pvi", description: "Positive Volume Index", categories: [:volume])
  indicator(:volume, endpoint: "volume", description: "Volume", categories: [:volume])
  indicator(:volumesplit, endpoint: "volumesplit", description: "Volume Split", categories: [:volume])

  # =============================================================================
  # Trend
  # =============================================================================

  indicator(:qstick, endpoint: "qstick", description: "Qstick", categories: [:trend])
  indicator(:vhf, endpoint: "vhf", description: "Vertical Horizontal Filter", categories: [:trend])
  indicator(:vortex, endpoint: "vortex", description: "Vortex", categories: [:trend])

  # =============================================================================
  # Statistic Functions
  # =============================================================================

  indicator(:beta, endpoint: "beta", description: "Beta", categories: [:statistic])
  indicator(:correl, endpoint: "correl", description: "Pearson's Correlation Coefficient", categories: [:statistic])
  indicator(:linearreg, endpoint: "linearreg", description: "Linear Regression", categories: [:statistic])

  indicator(:linearreg_angle,
    endpoint: "linearreg_angle",
    description: "Linear Regression Angle",
    categories: [:statistic]
  )

  indicator(:linearreg_intercept,
    endpoint: "linearreg_intercept",
    description: "Linear Regression Intercept",
    categories: [:statistic]
  )

  indicator(:linearreg_slope,
    endpoint: "linearreg_slope",
    description: "Linear Regression Slope",
    categories: [:statistic]
  )

  indicator(:tsf, endpoint: "tsf", description: "Time Series Forecast", categories: [:statistic])
  indicator(:var, endpoint: "var", description: "Variance", categories: [:statistic])

  # =============================================================================
  # Math Transform
  # =============================================================================

  indicator(:abs, endpoint: "abs", description: "Vector Absolute Value", categories: [:math])
  indicator(:atan, endpoint: "atan", description: "Vector Trigonometric ATan", categories: [:math])
  indicator(:ceil, endpoint: "ceil", description: "Vector Ceil", categories: [:math])
  indicator(:cos, endpoint: "cos", description: "Vector Trigonometric Cos", categories: [:math])
  indicator(:floor, endpoint: "floor", description: "Vector Floor", categories: [:math])
  indicator(:ln, endpoint: "ln", description: "Vector Log Natural", categories: [:math])
  indicator(:log10, endpoint: "log10", description: "Vector Log10", categories: [:math])
  indicator(:mul, endpoint: "mul", description: "Vector Multiplication", categories: [:math])
  indicator(:round, endpoint: "round", description: "Vector Round", categories: [:math])
  indicator(:sin, endpoint: "sin", description: "Vector Trigonometric Sin", categories: [:math])
  indicator(:tan, endpoint: "tan", description: "Vector Trigonometric Tan", categories: [:math])
  indicator(:tanh, endpoint: "tanh", description: "Vector Trigonometric Tanh", categories: [:math])
  indicator(:todeg, endpoint: "todeg", description: "Vector Degree Conversion", categories: [:math])
  indicator(:torad, endpoint: "torad", description: "Vector Radian Conversion", categories: [:math])
  indicator(:trunc, endpoint: "trunc", description: "Vector Truncate", categories: [:math])

  # =============================================================================
  # Math Operators
  # =============================================================================

  indicator(:add, endpoint: "add", description: "Vector Arithmetic Add", categories: [:math])
  indicator(:div, endpoint: "div", description: "Vector Arithmetic Div", categories: [:math])
  indicator(:max, endpoint: "max", description: "Highest value over period", categories: [:math])
  indicator(:maxindex, endpoint: "maxindex", description: "Index of highest value over period", categories: [:math])
  indicator(:min, endpoint: "min", description: "Lowest value over period", categories: [:math])
  indicator(:minindex, endpoint: "minindex", description: "Index of lowest value over period", categories: [:math])
  indicator(:minmax, endpoint: "minmax", description: "Lowest and highest values over period", categories: [:math])

  indicator(:minmaxindex,
    endpoint: "minmaxindex",
    description: "Indexes of lowest and highest values",
    categories: [:math]
  )

  indicator(:mult, endpoint: "mult", description: "Vector Arithmetic Mult", categories: [:math])
  indicator(:sqrt, endpoint: "sqrt", description: "Vector Square Root", categories: [:math])
  indicator(:sub, endpoint: "sub", description: "Vector Arithmetic Subtraction", categories: [:math])
  indicator(:sum, endpoint: "sum", description: "Summation", categories: [:math])

  # =============================================================================
  # Price
  # =============================================================================

  indicator(:avgprice, endpoint: "avgprice", description: "Average Price", categories: [:price])
  indicator(:candle, endpoint: "candle", description: "Candle", categories: [:price])
  indicator(:candles, endpoint: "candles", description: "Candles", categories: [:price])
  indicator(:medprice, endpoint: "medprice", description: "Median Price", categories: [:price])
  indicator(:price, endpoint: "price", description: "Price", categories: [:price])
  indicator(:priorswinghigh, endpoint: "priorswinghigh", description: "Prior Swing High", categories: [:price])
  indicator(:priorswinglow, endpoint: "priorswinglow", description: "Prior Swing Low", categories: [:price])
  indicator(:tr, endpoint: "tr", description: "True Range", categories: [:price])
  indicator(:typprice, endpoint: "typprice", description: "Typical Price", categories: [:price])
  indicator(:wclprice, endpoint: "wclprice", description: "Weighted Close Price", categories: [:price])

  # =============================================================================
  # Hilbert Transform
  # =============================================================================

  indicator(:ht_dcperiod,
    endpoint: "ht_dcperiod",
    description: "Hilbert Transform - Dominant Cycle Period",
    categories: [:math]
  )

  indicator(:ht_dcphase,
    endpoint: "ht_dcphase",
    description: "Hilbert Transform - Dominant Cycle Phase",
    categories: [:math]
  )

  indicator(:ht_phasor, endpoint: "ht_phasor", description: "Hilbert Transform - Phasor Components", categories: [:math])
  indicator(:ht_sine, endpoint: "ht_sine", description: "Hilbert Transform - SineWave", categories: [:math])

  indicator(:ht_trendmode,
    endpoint: "ht_trendmode",
    description: "Hilbert Transform - Trend vs Cycle Mode",
    categories: [:math]
  )

  # =============================================================================
  # Other
  # =============================================================================

  indicator(:fisher, endpoint: "fisher", description: "Fisher Transform", categories: [:oscillator])
  indicator(:msw, endpoint: "msw", description: "Mesa Sine Wave", categories: [:oscillator])
end
