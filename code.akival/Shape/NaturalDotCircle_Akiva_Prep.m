%% NaturalDot_Prep                                                                          
% vFPS = 60                                                                                 
% The data cleaning process is done as an abstraction                                       
[tAng, tDis] = getAngDis(d);                                                                
[dWid, dHig, hOff, tAng, color, polygonPoints] = dotCorrectedPositionalData(d, tAng, tDis); 
                                                                                            
% Dot height and width                                                                      
d.dWid(1) = dWid;                                                                           
d.dHig(1) = dHig;                                                                           
d.hOff(1) = hOff;                                                                           
                                                                                            
% Important stimulus stuff                                                                  
d.stimdatas.colors(1) = color;                                                              
d.stimdatas.bbox(1) = polygonPoints                                                         
d.stimdatas.centers(1) = hOff;                                                              
                                                                                            
d.tAng(1) = tAng;                                                                           
d.vblT = 0;                                                                                 
clear light;                                                                                
