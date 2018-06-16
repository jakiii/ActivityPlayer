package mmo.code.common
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mmo.common.user.UserInfo;
	import mmo.framework.comm.LoginDataContainer;
	import mmo.framework.comm.SocketClient;
	import mmo.framework.comm.SocketClientEvent;
	import mmo.framework.comm.statistic.SundriesClient;
	import mmo.interfaces.IInitService;
	import mmo.interfaces.ServiceContainer;
	import mmo.interfaces.material.furniture.IFurnitureService;
	import mmo.interfaces.task.ITaskService;

	public class LoadService
	{
		private const INIT_SERVICE_NAMES:Array = 
			[
				"TeamService","ItemService","AmountUpdateService","PetDataService","ClothesService","PetFightService",
				"PetCardService","PetCard2Service","PetCard3Service","InscriptionService","PlantService","PlantItemService",
				"ZooItemDataService","ZooAnimalDataService","FurnitureService","RobotItemService","PetEggService","UserNameManager",
				"SquadService","PMService","PetSkillMesService","PetDictionaryDataService","AntiAddictionService",
				"MiraclePetDataService","ArrowGuideService","BabyService"
			];
		private var servicesNames:Array;
		
		public function LoadService(serviceNames:Array)
		{
			this.servicesNames = serviceNames;
		}
		
		public function initServices():void
		{
			this.initData();
			var services:Array = [];
			for (var index:int = 0; index < this.servicesNames.length; index++)
			{
				var serviceName:String = this.servicesNames[index];
				var service:IInitService = ServiceContainer.getService(serviceName) as IInitService;
				if(INIT_SERVICE_NAMES.indexOf(serviceName) == -1)
				{
					continue;
				}
				if (service == null)
				{
					throw new Error("init error: " + serviceName + " undefine.");
					break;
				}
				services.push(service);
			}
			for each(var s:IInitService in services)
			{
				s.init();
			}
		}
		
		private const cmds:Array = ["10-0", "getUserClothes", "14_2", "61_6", "61_7",//id:4
			"61-8", "80_1", "77_1", "61_1", "81_2", //9
			"61_5", "2-6", "getUserInscription"];
		private function initData():void
		{
			UserInfo.sessionId = "502359";
			LoginDataContainer.instance.init();
			for each(var cmd:String in cmds)
			{
				SocketClient.instance.dispatchEvent(new SocketClientEvent(cmd,{}));
			}
			trace("ccccccccccccc:" + LoginDataContainer.instance.getParams("10-0"));
		}
	}
}