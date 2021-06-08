#property copyright "King of Kings"

int tick[1000];
int count = 0;
extern int risk_level = 280.0;

int OnInit()
{
   ArrayFill(tick, 0, 1000, 0);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){}
void RiskFree(){
    int order_count = OrdersTotal();
    for(int i = 0; i < OrdersTotal(); i++){
        if(OrderSelect(i, SELECT_BY_POS) == true){
            double profit = OrderProfit();
            if(profit >= ((risk_level) * OrderLots())){   
                bool xx = false;
                int ticket = OrderTicket();
                for(int j = 0; j < count; j++){
                    if(tick[j] == ticket){
                        xx = true;
                    }
                }
                if(xx == true) continue;
                double prev_stoploss = OrderStopLoss();
                double new_stoploss = OrderOpenPrice();
                bool modify = OrderModify(
                    ticket, //ticket
                    OrderOpenPrice(), // price
                    new_stoploss, // stoploss
                    OrderTakeProfit(), // takeprofit
                    NULL, // expiration
                    Yellow //color
                );
                tick[count] = ticket;
                count += 1;
                ArraySort(tick, WHOLE_ARRAY, 0, MODE_DESCEND);
                Alert("order Modified, result : ", modify);
                Alert("prev stop loss : ", prev_stoploss, " current stop loss : ", new_stoploss);
                Alert("Order Ticket : ", ticket);
                if(GetLastError() != 0) Alert("Error in risk free : ", GetLastError());
            }
        }
    }
}

void OnTick(){
   RiskFree();
}