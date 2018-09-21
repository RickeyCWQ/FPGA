LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;

ENTITY COUNT4 IS
PORT (clk,en,RST,suc,clear : in std_logic;
      
      cout,x: out std_logic;
      led4s:OUT STD_LOGIC_VECTOR(3 DOWNTO 0));     
 END ENTITY COUNT4;
 
 ARCHITECTURE bhv OF COUNT4 IS
signal q : std_logic_vector(3 downto 0);
 BEGIN

process(clk,rst,en)
begin

	if rst='0' then q <="0000" ;
	else 
		if suc='1' then 
			q<=q;
		elsif clk'event and clk='1' then
			if en='1' then 
				if q = 0 then 
					q <= q+1;
					x<='0';
				elsif q=1 then
					q<=q+1;
					x<='1';
				elsif q=2 then 
					x<='1';
					if clear='1' then 
						q<= (others=>'0');
						--------
						X<='0';
						--------
					end if;		      
				end if;
			end if;
		end if;
	end if;
	
end process;
  
  PROCESS(q)
begin
	CASE q IS
		WHEN "0000"=>led4s <= "0000";    
		WHEN "0001"=>led4s <= "0001";     
		WHEN "0010"=>led4s <= "0010";

		when others => led4s<="0000";
	end case;
  end process;
 end bhv;