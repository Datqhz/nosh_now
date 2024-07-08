namespace MyApp.Utils
{
    public static class DistanceUtil
    {
        public static double CalculateDistance(string coordinator1, string coordinator2)
        {
            var coords1 = coordinator1.Split('-');
            double lat1 = double.Parse(coords1[0].Trim());
            double lon1 = double.Parse(coords1[1].Trim());

            var coords2 = coordinator2.Split('-');
            double lat2 = double.Parse(coords2[0].Trim());
            double lon2 = double.Parse(coords2[1].Trim());
            
            const double R = 6371; 
            double dLat = ToRadians(lat2 - lat1);
            double dLon = ToRadians(lon2 - lon1);

            double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                    Math.Cos(ToRadians(lat1)) * Math.Cos(ToRadians(lat2)) *
                    Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

            return R * c; 
        }

        public static double ToRadians(double angleInDegrees)
        {
            return angleInDegrees * (Math.PI / 180);
        }
    }
}