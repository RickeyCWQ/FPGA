LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;

ENTITY COUNTS2 IS
PORT (clk,en,RST,suc : in std_logic;
      
      cout: out std_logic);     
 END ENTITY COUNTS2;
 
 ARCHITECTURE bhv OF COUNTS2 IS
signal q : std_logic_vector(3 downto 0);
 BEGIN

process(clk,rst,en)
			
		begin
			if rst='0' then q <="0000" ;
			 else if suc='1' then q<=q;
			 
			   elsif clk'event and clk='1' then
			  
			   if en='1' then 
			    if q < 5 then q <= q+1;   cout<='0';
			     else q<= (others=>'0') ; cout<='1';
			     
			    end if;
			   end if;
			 end if;
			 end if;
			
  end process;
  

 end bhv;