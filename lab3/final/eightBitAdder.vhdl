library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_Slice is
    Port(A: in std_logic;
        B: in std_logic;
        Cin: in std_logic;
        P: out std_logic;
        G: out std_logic;
        Sum_out: out std_logic);
end CLA_Slice;

architecture Behavioral of CLA_Slice is

begin
    Sum_Out<= A xor B xor Cin;
    P<=A xor B;
    G<=A and B;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_Block is
    Port(
    P: in std_logic_vector(7 downto 0);
    G: in std_logic_vector( 7 downto 0);
    Cout: out std_logic_vector (7 downto 0));
end CLA_Block;

architecture Behavioral of CLA_Block is

signal Cint:std_logic_vector (7 downto 0);

begin
    Cint(0)<=G(0);
    Cint(1)<=(Cint(0) and P(1)) or G(1);
    Cint(2)<=(Cint(1) and P(2)) or G(2);
    Cint(3)<=(Cint(2) and P(3)) or G(3);
    Cint(4)<=(Cint(3) and P(4)) or G(4);
    Cint(5)<=(Cint(4) and P(5)) or G(5);
    Cint(6)<=(Cint(5) and P(6)) or G(6);
    Cint(7)<=(Cint(6) and P(7)) or G(7);
    Cout<=Cint;
    
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity UNDERFLOWCHECK is
    Port(
        signA:      in std_logic;
        signB:      in std_logic;
        signR:      in std_logic;
        UF:         out std_logic);
end UNDERFLOWCHECK;

architecture behavioral of UNDERFLOWCHECK is

begin 
--process(signA,signB)
--    begin
--    if (signA=signB) then
--        if (signA=signR) then
--            if (signA='1') then
--                UF<='1';
--            end if;
--        end if;
--    else UF<='0';
--    end if;
--    end process;

UF<=(not(signA xor signB) and not(signR)) and signA;

end behavioral;
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eightbitadder is
    Port ( 
        A :         in  STD_LOGIC_VECTOR (7 downto 0);
        B :         in  STD_LOGIC_VECTOR (7 downto 0);
        Cin :       in std_logic;
        Sum :       out  STD_LOGIC_VECTOR (7 downto 0);
        CarryOut :  out  STD_LOGIC;
        UnderFlow:  out  STD_LOGIC);
end eightbitadder;

architecture Behavioral of eightbitadder is

component CLA_Slice
    Port(
    A,B,Cin:        in std_logic;
    P,G,Sum_out:    out std_logic);
end component;

component CLA_Block
    Port(
        P,G:in std_logic_vector(7 downto 0);
        Cout:out std_logic_vector(7 downto 0));
end component;

component UNDERFLOWCHECK
    Port(
            signA:      in std_logic;
            signB:      in std_logic;
            signR:      in std_logic;
            UF:         out std_logic);
end component;



signal Prop,Gen:            std_logic_vector (7 downto 0);
signal C_int :              std_logic_vector(7 downto 0);
signal sliceSevenSumOut:    std_logic;

begin
Inst_CLA_Slice0:    CLA_Slice Port map (A(0),B(0) ,'0'     ,Prop(0),Gen(0),Sum(0));
Inst_CLA_Slice1:    CLA_Slice Port map (A(1),B(1) ,C_int(0),Prop(1),Gen(1),Sum(1));
Inst_CLA_Slice2:    CLA_Slice Port map (A(2),B(2) ,C_int(1),Prop(2),Gen(2),Sum(2));
Inst_CLA_Slice3:    CLA_Slice Port map (A(3),B(3) ,C_int(2),Prop(3),Gen(3),Sum(3));
Inst_CLA_Slice4:    CLA_Slice Port map (A(4),B(4) ,C_int(3),Prop(4),Gen(4),Sum(4));
Inst_CLA_Slice5:    CLA_Slice Port map (A(5),B(5) ,C_int(4),Prop(5),Gen(5),Sum(5));
Inst_CLA_Slice6:    CLA_Slice Port map (A(6),B(6) ,C_int(5),Prop(6),Gen(6),Sum(6));
Inst_CLA_Slice7:    CLA_Slice Port map (A(7),B(7) ,C_int(6),Prop(7),Gen(7),sliceSevenSumOut);
Inst_CLA_Block:     CLA_Block Port map (P=> Prop,G=>Gen,Cout(7 downto 0)=>C_int);
Inst_UF:       UNDERFLOWCHECK Port map (A(7),B(7),sliceSevenSumOut,UF=>UnderFlow);

Sum(7)<=sliceSevenSumOut;
CarryOut<=C_int(6);

end Behavioral;
