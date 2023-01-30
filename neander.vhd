library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity neander is
    port(
        clock  : in std_logic;
        reset  : in std_logic;
        count_load : in std_logic;
        en_ULA : in std_logic;
       
        
        --SAIDAS
        Z : out std_logic;
        N : out std_logic;
        decoder : out std_logic_vector(3 downto 0)
	);
end neander;

architecture behavior of neander is
    --memoria 
    type valores is array (0 to 15) of std_logic_vector(7 downto 0);--vetor de 16 posi��es de 8 bits

    ----------------------------------------------------------------
    	--BITS MAIS SIGNIFICATiVOS CODIGO
    	--BITS Menos Significativos conta
    	signal memoria : valores:=  (0=>"10100001",
               		1=>"10100001",
               		2=>"00000000",
               		3=>"00000000",
               		4=>"00000000",
               		5=>"00000000",
               		6=>"00000000",
               		7=>"00000000",
               		8=>"00000000",
               		9=>"00000000",
               		10=>"00000000",
               		11=>"00000000",
               		12=>"00000000",
               		13=>"00000000",
               		14=>"00000000",
               		15=>"00000000"
               		);
    ----------------------------------------------------------------

    --MUX AND contas
    
    signal mux_ula: std_logic_vector(3 downto 0);
    signal SUM: std_logic_vector(3 downto 0);
    signal SUB:std_logic_vector(3 downto 0);
    signal mult: std_logic_vector(7 downto 0);
    signal comp: std_logic_vector(3 downto 0);

    signal RDM: std_logic_vector(7 downto 0);
    signal PC: std_logic_vector(3 downto 0);
    signal flag_z: std_logic;
    signal flag_n: std_logic;
    signal ACC: std_logic_vector(3 downto 0);



    begin
    
        --contas
        ---
        --IMPLEMENTANDO as contas da ULA
        SUM<=RDM(3 downto 0)+ACC;
        SUB<=RDM(3 downto 0)-ACC;
        mult<=RDM(3 downto 0)*ACC;
        --comp<=mux_ula=ACC;
        ---MUX ULA
        mux_ula<= "0000" & RDM(3 downto 0) when (RDM(5)='0' and RDM(4)= '0')else--LOAD
        "0000" & SUM(3 downto 0) when (RDM(5)='0' and RDM(4)= '1')else--SUM
        "0000" & SUB(3 downto 0) when (RDM(5)='1' and RDM(4)= '0')else--SUB
        "0000" & mult(7 downto 4) when (RDM(5)='1' and RDM(4)= '1');--MULT
        --Z E N
        flag_z<= '1' when (ACC= "0000") else '0';
        flag_n<= '1' when (ACC(3)='1') else '0';

        process(clock,reset)
        begin
            if reset = '0' then
                RDM <= (others => '0');
                PC <= (others => '0');
                flag_z <= '0';
                flag_n <= '0';
                ACC <= (others => '0');
                elsif rising_edge(clock) then
                    if count_load='1' then
                        PC<=PC+"0001";
                        RDM<=memoria(conv_integer(unsigned(PC)));--PODE SER TIRADO DO MUX TALVEZ
                        decoder<=RDM(7 downto 4);--DECODIFICADOR PEGA OS 4 BITS MAIS SIGNIFICATIVOS DO RDM
                        
                    else
                        PC<=RDM(4 downto 0);--PC PEGA OS 4 BITS MENOS SIGNIFICATIVOS
                        RDM<=memoria(conv_integer(unsigned(PC)));--PODE SER TIRADO DO MUX TALVEZ
                        decoder<=RDM(7 downto 4);--DECODIFICADOR PEGA OS 4 BITS MAIS SIGNIFICATIVOS DO RDM
                    end if;
			if en_ULA ='1' then
				ACC<=mux_ula;
			end if;
        end if;
	end process;
end architecture;