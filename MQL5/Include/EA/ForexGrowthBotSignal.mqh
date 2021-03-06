//+------------------------------------------------------------------+
//|                                           ForexMorningSignal.mqh |
//|                                                         Zephyrrr |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Zephyrrr"
#property link      "http://www.mql5.com"

#include <ExpertModel\ExpertModel.mqh>
#include <ExpertModel\ExpertModelSignal.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>

#include <Indicators\Oscilators.mqh>
#include <Indicators\TimeSeries.mqh>

#include "ForexGrowthBotLib.mqh"

// EURUSD, M15
class CForexGrowthBotSignal : public CExpertModelSignal
{
private:
    int gi_84;
    int g_timeframe_256;
    double gd_260;
    datetime g_datetime_176;
    int gi_180;
    double g_lots_212;
    double gd_236;
    
    double ProfitTarget, StopLoss;
    double LotSize;
    int FastVolatilityBase;
    int SlowVolatilityBase;
    double VolatilityFactor;
    int ProfitLossVolatilityBase;
    bool UseWaveTrailing;
    
    CiTime m_iTime;
    CiOpen m_iOpen;
    CiClose m_iClose;
    CiHigh m_iHigh;
    CiLow m_iLow;
    
    int Check();
    double m;
    int n;
public:
	CForexGrowthBotSignal();
	~CForexGrowthBotSignal();
	virtual bool      ValidationSettings();
	virtual bool      InitIndicators(CIndicators* indicators);

	virtual bool      CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration);
	virtual bool      CheckCloseLong(CTableOrder* t, double& price);
	virtual bool      CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration);
	virtual bool      CheckCloseShort(CTableOrder* t, double& price);
    virtual void PreProcess();
    
	void InitParameters();
};

void CForexGrowthBotSignal::InitParameters()
{
    UseWaveTrailing = false;
    
    ProfitTarget = 0.5;
    StopLoss = 0.2;
    LotSize = 0.1;
    FastVolatilityBase = 5;
    SlowVolatilityBase = 60;
    VolatilityFactor = 2.0;
    ProfitLossVolatilityBase = 50;
    
    gd_260 = 10.0;
    
	gi_84 = 9;
	double gd_244 = 250.0;
    int gi_252 = 240;
    gd_236 = 100000.0;
    string gs_140 = "40-80;40-80;40-80;40";
    
    MathSrand((int)TimeLocal());
    bool li_0 = false;
    if (UseWaveTrailing) li_0 = true;
   
   g_timeframe_256 = m_period;
   initQuant(gi_84, (int)gd_260, ProfitTarget, StopLoss, gd_244, gi_252, g_timeframe_256, gd_236, li_0, gs_140);
   //Print(gi_84, ",", (int)gd_260, ",", ProfitTarget, ",", StopLoss, ",", gd_244, ",", gi_252, ",", g_timeframe_256, ",", gd_236, ",", li_0, ",", gs_140);
   g_datetime_176 = m_iTime.GetData(0);
   gi_180 = 0;
   g_lots_212 = LotSize;
}

void CForexGrowthBotSignal::CForexGrowthBotSignal()
{
}

void CForexGrowthBotSignal::~CForexGrowthBotSignal()
{
}
bool CForexGrowthBotSignal::ValidationSettings()
{
	if(!CExpertSignal::ValidationSettings()) 
		return(false);

	if(false)
	{
		printf(__FUNCTION__+": Indicators should not be Null!");
		return(false);
	}
	return(true);
}

bool CForexGrowthBotSignal::InitIndicators(CIndicators* indicators)
{
	if(indicators==NULL) 
		return(false);
	bool ret = true;

	ret &= m_iTime.Create(m_symbol.Name(), m_period);
    ret &= m_iOpen.Create(m_symbol.Name(), m_period);
    ret &= m_iClose.Create(m_symbol.Name(), m_period);
    ret &= m_iHigh.Create(m_symbol.Name(), m_period);
    ret &= m_iLow.Create(m_symbol.Name(), m_period);
    
	ret &= indicators.Add(GetPointer(m_iTime));
    ret &= indicators.Add(GetPointer(m_iOpen));
    ret &= indicators.Add(GetPointer(m_iClose));
    ret &= indicators.Add(GetPointer(m_iHigh));
    ret &= indicators.Add(GetPointer(m_iLow));
    
	return ret;
}

int CForexGrowthBotSignal::Check()
{
    int gi_156 = 25;
    
    double ld_0;
   double lda_12[];
   double lda_16[];
   double ld_20;
   int li_28;
   double ld_32;
   double ld_40;
   double ld_48;
   double ld_56;
   int li_64 = 0;
   int l_timeframe_68 = m_period;
   int l_count_72 = 0;

   if (m_iTime.GetData(0) - g_datetime_176 >= l_timeframe_68) {
      gi_180 += m_period;
      ld_0 = 0;
      
      int gi_160 = 0;
      int gi_164 = 0;
    int gi_168 = 1;
     
     ArraySetAsSeries(lda_12, true);
     ArraySetAsSeries(lda_16, true);
     
      for (ld_0 = gi_160; ld_0 <= gi_164; ld_0++) {
         for (l_count_72 = 0; l_count_72 < gi_168; l_count_72++) {
         
            m_iClose.GetData(1, 100, lda_12);
            m_iOpen.GetData(1, 100, lda_16);
             
            //ArrayCopy(lda_12, Close, 0, 1, 100);
            //ArrayCopy(lda_16, Open, 0, 1, 100);
            
            int l_index_76;
            ld_20 = 0;
            if (ld_0 > 0.0) {
               for (l_index_76 = 0; l_index_76 < ArraySize(lda_12); l_index_76++) {
                  if (MathRand() > 16383) ld_20 = (MathRand() + 0.0000001) / 32767.0 * (ld_0 * m_symbol.Point() * 10);
                  else ld_20 = (-(MathRand() + 0.0000001)) / 32767.0 * (ld_0 * m_symbol.Point() * 10);
                  lda_12[l_index_76] += ld_20;
               }
               for (l_index_76 = 0; l_index_76 < ArraySize(lda_16); l_index_76++) {
                  if (MathRand() > 16383) ld_20 = (MathRand() + 0.0000001) / 32767.0 * (ld_0 * m_symbol.Point() * 10);
                  else ld_20 = (-(MathRand() + 0.0000001)) / 32767.0 * (ld_0 * m_symbol.Point() * 10);
                  lda_16[l_index_76] += ld_20;
               }
            }
            ld_32 = GetVolatilityRatio(lda_12, lda_16, FastVolatilityBase, SlowVolatilityBase, 100);
            
            g_datetime_176 = m_iTime.GetData(0);//iTime(NULL, Period(), 0);
            li_28 = 0;
            
            //Print(lda_12[0], ", ",  lda_12[50], ", ", lda_16[0], ", ", lda_16[50], ", ", ld_32, ",", FastVolatilityBase, ",", SlowVolatilityBase);
            if (MathAbs(ld_32) > VolatilityFactor) {
               if (ld_32 > 0.0) li_28 = 1;
               else li_28 = -1;
            }
            ld_40 = ProfitTarget;
            ld_48 = StopLoss;
            //ld_56 = High[iHighest(NULL, 0, MODE_HIGH, ProfitLossVolatilityBase, 1)] - Low[iLowest(NULL, 0, MODE_LOW, ProfitLossVolatilityBase, 1)];
            int idx;
            ld_56 = m_iHigh.MaxValue(1, ProfitLossVolatilityBase, idx) - m_iLow.MinValue(1, ProfitLossVolatilityBase, idx);
            ld_56 *= gd_236;
            li_64 = GetQuantPositionChange(gi_84, 0, gi_156, lda_12[0], li_28, gi_180, ld_40, ld_48, ld_56);
            
            // li_64代表Buy Or Sell 多少，+代表Buy
            // if (li_64 != 0) AdjustPosition(li_64);
            if (li_28 != 0) {
               break;
            }
         }
      }
   }
   
   return li_64;
}

void CForexGrowthBotSignal::PreProcess()
{
    CExpertModel* em = (CExpertModel *)m_expert;

    n = Check();
    m = em.GetPosition();
    
    //if (n != 0) Print("n=", n, ",m=", m);
}

bool CForexGrowthBotSignal::CheckOpenLong(double& price,double& sl,double& tp,datetime& expiration)
{
    CExpertModel* em = (CExpertModel *)m_expert;
    if (m != 0)
        return false;
        
	if (n > 0 && m < n)
	{
	    price = m_symbol.Ask();
	    
	    //Print("OpenLong");
		return true;
	}
		
	return false;
}

bool CForexGrowthBotSignal::CheckOpenShort(double& price,double& sl,double& tp,datetime& expiration)
{
    CExpertModel* em = (CExpertModel *)m_expert;
    if (m != 0)
        return false;
        
	if (n < 0 && m > n)
	{
	    price = m_symbol.Bid();
	    //Print("OpenShort");
		return true;
	}

	return false;
}

bool CForexGrowthBotSignal::CheckCloseLong(CTableOrder* t, double& price)
{
    CExpertModel* em = (CExpertModel *)m_expert;
   
    if (n != 0 && m > n)
	{
	    price = m_symbol.Bid();
	    //Print("GetCloseLongSignal");
		return true;
	}

	return false;
}

bool CForexGrowthBotSignal::CheckCloseShort(CTableOrder* t, double& price)
{
	CExpertModel* em = (CExpertModel *)m_expert;
    if (n != 0 && m < n)
	{
	    price = m_symbol.Ask();
	    //Print("GetCloseShortSignal");
		return true;
	}
	
    return false;
}
