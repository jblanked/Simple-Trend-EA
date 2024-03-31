//+------------------------------------------------------------------+
//|                                              Simple-Trend-EA.mq5 |
//|                                          Copyright 2024,JBlanked |
//|                                        https://www.jblanked.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024,JBlanked"
#property link      "https://www.jblanked.com/"
#property version   "1.00"
#include <trade/trade.mqh>
CTrade trade;

double rsi[], fastMA[], slowMA[];
int rsiHandle, fastMAHandle, slowMAHandle;

input double lotsSize = 0.10; // Lotsize
input double stoploss = 10; // Stop Loss
input double takeprofit = 40; // Take Profit
input long  magicnumber = 12343435; // Magic Number
input string ordercomment = "Simple-Trend-EA"; // Order Comment
double pipvalue;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   rsiHandle = iRSI(_Symbol,PERIOD_CURRENT,14,PRICE_CLOSE);
   fastMAHandle = iMA(_Symbol,PERIOD_CURRENT,50,0,MODE_EMA,PRICE_CLOSE);
   slowMAHandle = iMA(_Symbol,PERIOD_CURRENT,200,0,MODE_EMA,PRICE_CLOSE);
   
   if(rsiHandle == INVALID_HANDLE || 
      fastMAHandle == INVALID_HANDLE || 
      slowMAHandle == INVALID_HANDLE) return INIT_FAILED;
      
      else
      {
      
      ArraySetAsSeries(rsi,true);
      ArraySetAsSeries(fastMA,true);
      ArraySetAsSeries(slowMA,true);
      
      ArrayInitialize(rsi,EMPTY_VALUE);
      ArrayInitialize(fastMA,EMPTY_VALUE);
      ArrayInitialize(slowMA,EMPTY_VALUE);
      
      pipvalue = _Point * 10;
   
//---
      return(INIT_SUCCEEDED);
   }
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(PositionsTotal()<1)
   {
   CopyBuffer(rsiHandle,0,0,3,rsi);
   CopyBuffer(fastMAHandle,0,0,3,fastMA);
   CopyBuffer(slowMAHandle,0,0,3,slowMA);
   
   // if fast EMA > slow EMA and rsi > 50 - buy
   // if fast EMA < slow EMA and rsi < 50 - sell
   
   double askPrice = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   
   if(fastMA[1] > slowMA[1] && rsi[1] > 50)
   {
   // buy
   trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,lotsSize,askPrice,askPrice - stoploss * pipvalue,askPrice + takeprofit * pipvalue,ordercomment);
   }
   else if(fastMA[1] < slowMA[1] && rsi[1] < 50)
   {
   // sell
  trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,lotsSize,askPrice,bidPrice + stoploss * pipvalue,bidPrice - takeprofit * pipvalue,ordercomment);
   }
   }
   
  }
//+------------------------------------------------------------------+
