using System.Windows;

namespace NewsSightseeing.Data.Utility
{
    using System;

    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var aggregator = new AxelSpringerIpoolAggregator();
            aggregator.Aggregate();
        }
    }
}
