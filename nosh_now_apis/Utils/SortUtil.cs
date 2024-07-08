using MyApp.Dtos.Response;

namespace MyApp.Utils
{
    public static class SortUtil
    {
        public static void SortOrderByDistance(List<OrderAndDistanceResponseDto> list, int left, int right)
    {
        if (left < right)
        {
            int pivotIndex = Partition(list, left, right);
            SortOrderByDistance(list, left, pivotIndex - 1);
            SortOrderByDistance(list, pivotIndex + 1, right);
        }
    }

        private static int Partition(List<OrderAndDistanceResponseDto> list, int left, int right)
        {
            double pivot = list[right].distance;
            int i = left - 1;

            for (int j = left; j < right; j++)
            {
                if (list[j].distance <= pivot)
                {
                    i++;
                    Swap(list, i, j);
                }
            }

            Swap(list, i + 1, right);
            return i + 1;
        }

        private static void Swap(List<OrderAndDistanceResponseDto> list, int i, int j)
        {
            OrderAndDistanceResponseDto temp = list[i];
            list[i] = list[j];
            list[j] = temp;
        }
    }
}