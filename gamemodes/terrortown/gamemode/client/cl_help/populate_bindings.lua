local function AddBindingCategory(category, parent)
	local form = vgui.Create("DFormTTT2", parent)

	form:SetName(category)

	for _, binding in ipairs(bind.GetSettingsBindings()) do
		if binding.category == category then
			-- creating two grids:
			-- GRID: tooltip, bindingbutton and extra button area
			-- GRIDEXTRA: inside the last GRID box, houses default and disable buttons
			local dPGrid = vgui.Create("DGrid")
			dPGrid:SetCols(3)
			dPGrid:SetColWide(120)

			local dPGridExtra = vgui.Create("DGrid")
			dPGridExtra:SetCols(2)
			dPGridExtra:SetColWide(60)

			form:AddItem(dPGrid)

			-- Keybind Label
			local dPlabel = vgui.Create("DLabel")
			dPlabel:SetText(binding.label .. ":")
			dPlabel:SetTextColor(COLOR_BLACK)
			dPlabel:SetContentAlignment(4)
			dPlabel:SetSize(120, 25)

			dPGrid:AddItem(dPlabel)


			-- Keybind Button
			local dPBinder = vgui.Create("DBinderTTT2")
			dPBinder:SetSize(100, 25)

			local curBinding = bind.Find(binding.name)
			dPBinder:SetValue(curBinding)
			dPBinder:SetTooltip("f1_bind_description")

			dPGrid:AddItem(dPBinder)
			dPGrid:AddItem(dPGridExtra)

			-- DEFAULT Button
			local dPBindResetButton = vgui.Create("DButton")
			dPBindResetButton:SetText("f1_bind_reset_default")
			dPBindResetButton:SetSize(55, 25)
			dPBindResetButton:SetTooltip("f1_bind_reset_default_description")

			if binding.defaultKey ~= nil then
				dPBindResetButton.DoClick = function()
					bind.Set(binding.defaultKey, binding.name, true)
					dPBinder:SetValue(bind.Find(binding.name))
				end
			else
				dPBindResetButton:SetDisabled(true)
			end
			dPGridExtra:AddItem(dPBindResetButton)

			-- DISABLE Button
			local dPBindDisableButton = vgui.Create("DButton")
			dPBindDisableButton:SetText("f1_bind_disable_bind")
			dPBindDisableButton:SetSize(55, 25)
			dPBindDisableButton:SetTooltip("f1_bind_disable_description")
			dPBindDisableButton.DoClick = function()
				bind.Remove(curBinding, binding.name, true)
				dPBinder:SetValue(bind.Find(binding.name))
			end
			dPGridExtra:AddItem(dPBindDisableButton)

			-- onchange function
			function dPBinder:OnChange(num)
				bind.Remove(curBinding, binding.name, true)

				if num ~= 0 then
					bind.Add(num, binding.name, true)
				end

				LocalPlayer():ChatPrint(GetPTranslation("ttt2_bindings_new", {name = binding.name, key = input.GetKeyName(num) or "NONE"}))

				curBinding = num
			end
		end
	end

	form:Dock(TOP)
end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("f1_settings_bindings_title")
	bindingsData:SetDescription("Some cool text will be here...")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_bindings"] = function(helpData, id)
	local bindingsData = helpData:PopulateSubMenu(id .. "_bindings")

	bindingsData:SetTitle("ttt2_bindings")
	bindingsData:PopulatePanel(function(parent)
		AddBindingCategory("TTT2 Bindings", parent)

		for k, category in ipairs(bind.GetSettingsBindingsCategories()) do
			if k > 2 then
				AddBindingCategory(category, parent)
			end
		end

		AddBindingCategory("Other Bindings", parent)
	end)
end