using MyApp.Dtos;
using MyApp.Dtos.Response;

namespace MyApp.Utils
{
    public static class SortUtil
    {
        public static void SortOrderByDistance<T>(List<T> list, int left, int right) where T : IDistance
    {
        if (left < right)
        {
            int pivotIndex = Partition(list, left, right);
            SortOrderByDistance(list, left, pivotIndex - 1);
            SortOrderByDistance(list, pivotIndex + 1, right);
        }
    }

        private static int Partition<T>(List<T> list, int left, int right) where T : IDistance
        {
            double pivot = list[right].Distance;
            int i = left - 1;

            for (int j = left; j < right; j++)
            {
                if (list[j].Distance <= pivot)
                {
                    i++;
                    Swap(list, i, j);
                }
            }

            Swap(list, i + 1, right);
            return i + 1;
        }

        private static void Swap<T>(List<T> list, int i, int j) where T : IDistance
        {
            var temp = list[i];
            list[i] = list[j];
            list[j] = temp;
        }
    }
}