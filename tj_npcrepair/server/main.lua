ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('paraal')
AddEventHandler('paraal', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = math.random(2000,5000)
    if xPlayer.getAccount('money').money >= money then
		cb(true)
        xPlayer.removeMoney(money)
	else
		cb(false)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yeterli paranız yok!' })
	end
end)



ESX.RegisterServerCallback('trojen_npcrepair:mekanikvarmı', function(source, cb)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'mechanic' then
            cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)


function trojenaractamirlog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
   
    local discord_webhook = "Webhook Ekleyiniz"
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = "Trojen Log Sistemi",
      ["avatar_url"] = "Logo Ekleyiniz",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName .. ' - ' .. xPlayer.identifier 
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end
