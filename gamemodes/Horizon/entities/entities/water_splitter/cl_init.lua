include('shared.lua')
 
function ENT:Draw( )
	
		if self.dispEnergy == nil then
			self.dispEnergy = 0
		end
		
		if self.dispWater == nil then
			self.dispWater = 0
		end
			
	local pl = LocalPlayer();
	if( IsValid( pl ) ) then

		local tr = pl:GetEyeTrace();				
		if( tr.Entity == self ) then
		
			if( EyePos():Distance( self:GetPos() ) < 512 ) then
				
				AddWorldTip( nil, "Water Splitter\n" .. "Energy: ".. self.dispEnergy .. "\nWater: " .. self.dispWater, nil, self:LocalToWorld( self:OBBCenter() ), NULL );
			
			end
		
		end
		
	end

	self:DrawModel();
	Wire_Render(self.Entity)

end

function gen_umsg_hook( um )
	
	local entity = um:ReadEntity()	
	entity.dispEnergy = um:ReadShort()
	entity.dispWater = um:ReadShort()
	
end
usermessage.Hook("water_splitter_umsg", gen_umsg_hook)